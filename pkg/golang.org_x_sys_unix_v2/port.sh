#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )
FILE_DIR=${BASH_DIR}/files

source ${BASH_DIR}/../../common.sh

SW64_UNIX=${BASH_DIR}/go-sw64-1.20.10-unix

info "Copying: $( ls ${SW64_UNIX} | tr '\n' ' ')"
cp ${SW64_UNIX}/*sw64* ${WORK_DIR}

info "Processing ..."

##### zsyscall_linux_sw64.go

# If fileHandle is not defined, remove functions nameToHandleAt and openByHandleAt
if [ -z "$( grep -r "type fileHandle" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove function nameToHandleAt"
	LINE=$( grep -n "func nameToHandleAt" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 11 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove function openByHandleAt"
	LINE=$( grep -n "func openByHandleAt" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 7 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# If RemoteIovec is not defined, remove functions ProcessVMReadv and ProcessVMWritev
if [ -z "$( grep -r "type RemoteIovec" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove function ProcessVMReadv"
	LINE=$( grep -n "func ProcessVMReadv" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 19 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove function ProcessVMWritev"
	LINE=$( grep -n "func ProcessVMWritev" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 19 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Remove redeclared functions Prlimit and Setrlimit
# see: https://github.com/golang/sys/commit/ff18efa0a3fa22d4fede381b822bbcfe53b7ee7c
if [ -f ${WORK_DIR}/syscall_linux.go ] && [ -n "$( grep "func Prlimit" ${WORK_DIR}/syscall_linux.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove redeclared function Prlimit"
	LINE=$( grep -n "func Prlimit" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove redeclared function Setrlimit"
	LINE=$( grep -n "func Setrlimit" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Remove redeclared function Pselect
if [ -f ${WORK_DIR}/syscall_linux.go ] && [ -n "$( grep "func Pselect" ${WORK_DIR}/syscall_linux.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove redeclared function Pselect"
	LINE=$( grep -n "func Pselect" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 7 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Remove redeclared function Getrandom
# The function was moved from zsyscall_linux.go to syscall_linux.go since v0.26.0
# see: https://github.com/golang/sys/commit/981de40f5c9d8dc49087c2d351624288ee17b34c
if [ -f ${WORK_DIR}/syscall_linux.go ] && [ -n "$( grep "func Getrandom" ${WORK_DIR}/syscall_linux.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove redeclared function Getrandom"
	LINE=$( grep -n "func Getrandom" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 13 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Remove function PidfdSendSignal using undefined type Siginfo
# see: https://github.com/golang/sys/commit/a9b59b0215f867c0675d50602208ab8c4f4fe9c7
if [ -z "$( grep -r --exclude=*sw64* "func PidfdSendSignal" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove function PidfdSendSignal using undefined type"
	LINE=$( grep -n "func PidfdSendSignal" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# If dup2 is defined in zsyscall_linux*, add function dup2
if [ -n "$( grep "func dup2" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function dup2"
	cat ${FILE_DIR}/dup2.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# If fcntl is defined in zsyscall_linux*, add function fcntl
if [ -n "$( grep "func fcntl" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function fcntl"
	cat ${FILE_DIR}/fcntl.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add functions Setregid, Setresgid, Setresuid and Setreuid
# see: https://github.com/golang/sys/commit/d0df966e6959f00dc1c74363e537872647352d51
if [ -n "$( grep "func Setregid" ${WORK_DIR}/zsyscall_linux_* )" ]; then
	warn "  zsyscall_linux_sw64.go: Add functions Setregid, Setresgid, Setreuid and Setresuid"
	cat ${FILE_DIR}/Setre*id.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function ptracePtr
if [ -n "$( grep -r "func ptracePtr" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function ptracePtr"
	cat ${FILE_DIR}/ptracePtr.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add functions getresuid and getresgid
if [ -n "$( grep -r "func getresuid" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add functions getresuid and getresgid"
	cat ${FILE_DIR}/getres*id.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function mremap
if [ -n "$( grep -r "func mremap" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function mremap"
	cat ${FILE_DIR}/mremap.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function pselect6
if [ -n "$( grep -r "func pselect6" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function pselect6"
	cat ${FILE_DIR}/pselect6.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add functions schedSetattr and schedGetattr
# https://github.com/golang/sys/commit/ee578879d89c195b56ae72143c652798925c5696
if [ -n "$( grep -r "func schedSetattr" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add functions schedSetattr and schedGetattr"
	cat ${FILE_DIR}/sched*etattr.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# TODO: This should be corrected when sw_64 supports Linux 6.6
# Add fake function fchmodat2
# https://github.com/golang/sys/commit/2d0c73638b2c8ff6b776ac86fdcf56fa33e362db
if [ -n "$( grep -r "func fchmodat2" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add fake function fchmodat2"
	cat ${FILE_DIR}/fchmodat2.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "/import/a\\\t\"errors\"" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function fsconfig
# see: https://github.com/golang/sys/commit/360f961f8978a4c9a7c2e849bb482780cd6bb553
if [ -n "$( grep -r "func fsconfig" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function fsconfig"
	cat ${FILE_DIR}/fsconfig.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function Faccessat
# see: https://github.com/golang/sys/commit/ad87a3a340fa7f3bed189293fbfa7a9b7e021ae1
if [ -z "$( grep "func Faccessat(" ${WORK_DIR}/syscall_linux.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function Faccessat"
	cat ${FILE_DIR}/Faccessat.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# pread -> Pread
# pwrite -> Pwrite
# see: https://github.com/golang/sys/commit/039c03cc5b867cd7b06a19ff375be5c945c80b10
if [ -n "$( grep "func Pread(" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Export functions pread and pwrite"
	sed -i "s@func pread(@func Pread(@" ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "s@func pwrite(@func Pwrite(@" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Replace function futimesat with old implementation
# see: https://github.com/golang/sys/commit/fc8bd948cf46f9c7af0f07d34151ce25fe90e477
if [ -n "$( grep "func futimesat(" ${WORK_DIR}/zsyscall_linux_*.go | grep byte )" ]; then
	warn  "  zsyscall_linux_sw64.go: Replace futimesat with old implementation"
	LINE=$( grep -n "func futimesat(" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 11 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go
	cat ${FILE_DIR}/futimesat_old.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Convert RawSyscallNoError -> RawSyscall, SyscallNoError -> Syscall
# SyscallNoError and RawSyscallNoError were added since v0.1.0 (2018-01-04)
# see: https://github.com/golang/sys/commit/28a7276518d399b9634904daad79e18b44d481bc
if [ -z "$( grep "NoError" --exclude=*sw64* ${WORK_DIR}/zsyscall_linux_*.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Convert RawSyscallNoError -> RawSyscall, SyscallNoError -> Syscall"
	sed -i "s@ := RawSyscallNoError@, _ := RawSyscallNoError@g" ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "s@ := SyscallNoError@, _ := SyscallNoError@g" ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "s@NoError@@g" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

##### syscall_linux_sw64.go

# Add function Pipe
# Pipe was implement using pipe2 syscall since 2021-09-18
# see: https://github.com/golang/sys/commit/d61c044b1678dd399c134e065f64eee6b231e119
if [ -n "$( grep "func Pipe(" ${WORK_DIR}/syscall_linux_*.go )" ]; then
	warn "  syscall_linux_sw64.go: Add function Pipe"
	cat ${FILE_DIR}/Pipe.go >> ${WORK_DIR}/syscall_linux_sw64.go
fi

# Add function Pipe2
if [ -n "$( grep "func Pipe2" ${WORK_DIR}/syscall_linux_*.go )" ]; then
	warn "  syscall_linux_sw64.go: Add function Pipe2"
	cat ${FILE_DIR}/Pipe2.go >> ${WORK_DIR}/syscall_linux_sw64.go
fi

# Add function InotifyInit
# InotifyInit was implement using InotifyInit1 in syscall_linux.go since 2021-09-07, it was previously undefined
# on sw64 and need to be added separately
# see: https://github.com/golang/sys/commit/6f6e22806c3450b5b4d275e186976d3b5758db41
if [ -z "$( grep "func InotifyInit(" ${WORK_DIR}/syscall_linux.go )" ]; then
    warn "  syscall_linux_sw64.go: Add function InotifyInit"
    cat ${FILE_DIR}/InotifyInit.go >> ${WORK_DIR}/syscall_linux_sw64.go
fi

##### ztypes_linux_sw64.go

# Sizeof(Ptr|Short|Int|Long|LongLong) -> sizeof(Ptr|Short|Int|Long|LongLong)
# see: https://github.com/golang/sys/commit/8469e314837c2e2471561de5c47bbf8bfd0d9099
if [ -f ${WORK_DIR}/ztypes_linux_amd64.go ] && [ -n "$( grep "sizeofPtr" ${WORK_DIR}/ztypes_linux_amd64.go )" ]; then
	warn "  ztypes_linux_sw64.go: Unexport Sizeof(Ptr|Short|Int|Long|LongLong)"
	for i in Ptr Short Int Long LongLong; do
		sed -i "s@Sizeof$i@sizeof$i@" ${WORK_DIR}/ztypes_linux_sw64.go
	done
fi

# Add struct FileDedupeRange
if [ -f ${WORK_DIR}/ztypes_linux.go ] && [ -n "$( grep "type FileDedupeRange" ${WORK_DIR}/ztypes_linux.go )" ]; then
	warn "  ztypes_linux_sw64.go: Add struct FileDedupeRange"
	cat ${FILE_DIR}/FileDedupeRange.go >> ${WORK_DIR}/ztypes_linux_sw64.go
fi

# Add struct sigset_argpack
if [ -f ${WORK_DIR}/ztypes_linux.go ] && [ -n "$( grep "type sigset_argpack" ${WORK_DIR}/ztypes_linux.go )" ]; then
	warn "  ztypes_linux_sw64.go: Add struct sigset_argpack"
	cat ${FILE_DIR}/sigset_argpack.go >> ${WORK_DIR}/ztypes_linux_sw64.go
fi

# Add struct SchedAttr
# https://github.com/golang/sys/commit/ee578879d89c195b56ae72143c652798925c5696
if [ -n "$( grep -r "type SchedAttr" ${WORK_DIR} )" ]; then
	warn "  ztypes_linux_sw64.go: Add struct SchedAttr and const SizeofSchedAttr"
	cat ${FILE_DIR}/SchedAttr.go >> ${WORK_DIR}/ztypes_linux_sw64.go
fi

# Add struct LoopConfig
# https://github.com/golang/sys/commit/13b15b780d9013988b1fb0e79e30b2528a877638
if [ -n "$( grep -r "type LoopConfig" ${WORK_DIR} )" ]; then
	warn "  ztypes_linux_sw64.go: Add struct LoopConfig"
	cat ${FILE_DIR}/LoopConfig.go >> ${WORK_DIR}/ztypes_linux_sw64.go
fi

##### z*_linux.go

for i in ztypes zerrors zsyscall; do
    if [ -f ${WORK_DIR}/${i}_linux.go ]; then
        info "Processing: ${i}_linux.go"
        [ -z "$( grep "sw64" ${WORK_DIR}/${i}_linux.go )" ] && \
        sed -i "/\/\/ +build linux/a\\\/\/ +build \!sw64" ${WORK_DIR}/${i}_linux.go && \
        sed -i "s@//go:build linux@//go:build linux \&\& \!sw64@" ${WORK_DIR}/${i}_linux.go
    fi
done

##### endian_little.go

if [ -f ${WORK_DIR}/endian_little.go ]; then
	info "Processing: endian_little.go"
	sed -i "s@// +build 386@// +build sw64 386@" ${WORK_DIR}/endian_little.go
	sed -i "s@//go:build 386@//go:build sw64 \|\| 386@" ${WORK_DIR}/endian_little.go
fi

success "Done."
