#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )
FILE_DIR=${BASH_DIR}/files

source ${BASH_DIR}/../../common.sh

SW64_UNIX=${BASH_DIR}/go-sw64-1.18.7-unix

info "Copying: $( ls ${SW64_UNIX} | tr '\n' ' ')"
cp ${SW64_UNIX}/*sw64* ${WORK_DIR}

info "Processing ..."

##### zsyscall_linux_sw64.go

# if fileHandle is not defined, remove functions nameToHandleAt and openByHandleAt
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

# if RemoteIovec is not defined, remove functions ProcessVMReadv and ProcessVMWritev
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

# if dup2 is defined, add function dup2
if [ -n "$( grep "func dup2" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function dup2"
	cat ${FILE_DIR}/dup2.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# if fcntl is defined, add function fcntl
if [ -n "$( grep "func fcntl" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function fcntl"
	cat ${FILE_DIR}/fcntl.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Pread -> pread
# Pwrite -> pwrite
# see: https://github.com/golang/sys/commit/039c03cc5b867cd7b06a19ff375be5c945c80b10
if [ -n "$( grep "func pread(" ${WORK_DIR}/zsyscall_linux* )" ]; then
	warn "  zsyscall_linux_sw64.go: Unexport functions Pread and Pwrite"
	sed -i "s@func Pread(@func pread(@" ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "s@func Pwrite(@func pwrite(@" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Remove redeclared functions Setregid, Setresgid, Setresuid and Setreuid
# see: https://github.com/golang/sys/commit/d0df966e6959f00dc1c74363e537872647352d51
if [ -f ${WORK_DIR}/syscall_linux.go ] && [ -n "$( grep "func Setregid" ${WORK_DIR}/syscall_linux.go )" ]; then
	warn "  zsyscall_linux_sw64.go: Remove redeclared function Setregid"
	LINE=$( grep -n "func Setregid" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove redeclared function Setresgid"
	LINE=$( grep -n "func Setresgid" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove redeclared function Setresuid"
	LINE=$( grep -n "func Setresuid" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
	sed -i "${START},${END}d" ${WORK_DIR}/zsyscall_linux_sw64.go

	warn "  zsyscall_linux_sw64.go: Remove redeclared function Setreuid"
	LINE=$( grep -n "func Setreuid" ${WORK_DIR}/zsyscall_linux_sw64.go | cut -d':' -f'1' )
	START=$(( $LINE - 3 ))
	END=$(( $LINE + 6 ))
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

# Add function rtSigprocmask
if [ -n "$( grep -r "func rtSigprocmask" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function rtSigprocmask"
	cat ${FILE_DIR}/rtSigprocmask.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function ptracePtr
if [ -n "$( grep -r "func ptracePtr" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function ptracePtr"
	cat ${FILE_DIR}/ptracePtr.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function func getresuid and getresgid
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

# Add function schedSetattr and schedGetattr
# https://github.com/golang/sys/commit/ee578879d89c195b56ae72143c652798925c5696
if [ -n "$( grep -r "func schedSetattr" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function schedSetattr and schedGetattr"
	cat ${FILE_DIR}/sched*etattr.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function PidfdSendSignal
# see: https://github.com/golang/sys/commit/a9b59b0215f867c0675d50602208ab8c4f4fe9c7
if [ -n "$( grep -r "func PidfdSendSignal" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function PidfdSendSignal"
	cat ${FILE_DIR}/PidfdSendSignal.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function Waitid
# see: https://github.com/golang/sys/commit/36772127a21fa5a8ea615746594d2f22f7d1607e
if [ -n "$( grep -r "func Waitid" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function Waitid"
	cat ${FILE_DIR}/Waitid.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# TODO: This should be corrected when sw_64 supports Linux 6.6
# Add fake function fchmodat2
# https://github.com/golang/sys/commit/2d0c73638b2c8ff6b776ac86fdcf56fa33e362db
if [ -n "$( grep -r "func fchmodat2" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add fake function fchmodat2"
	cat ${FILE_DIR}/fchmodat2.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
	sed -i "/import/a\\\t\"errors\"" ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function MoveMount
# see: https://github.com/golang/sys/commit/289d7a0edf712062d9f1484b07bdf2383f48802f
if [ -n "$( grep -r "func MoveMount" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function MoveMount"
	cat ${FILE_DIR}/MoveMount.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function OpenTree
# see: https://github.com/golang/sys/commit/483a9cbc67c01f740bb259a7f11f6a2f99b63256
if [ -n "$( grep -r "func OpenTree" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function OpenTree"
	cat ${FILE_DIR}/OpenTree.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function Fsmount, Fsopen and Fspick
# see: https://github.com/golang/sys/commit/889880a91fd53863df84d3684d6bf98ff24bb804
if [ -n "$( grep -r "func Fsmount" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function Fsmount, Fsopen and Fspick"
	cat ${FILE_DIR}/Fsmount.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
	cat ${FILE_DIR}/Fsopen.go  >> ${WORK_DIR}/zsyscall_linux_sw64.go
	cat ${FILE_DIR}/Fspick.go  >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

# Add function fsconfig
# see: https://github.com/golang/sys/commit/360f961f8978a4c9a7c2e849bb482780cd6bb553
if [ -n "$( grep -r "func fsconfig" ${WORK_DIR} )" ]; then
	warn "  zsyscall_linux_sw64.go: Add function fsconfig"
	cat ${FILE_DIR}/fsconfig.go >> ${WORK_DIR}/zsyscall_linux_sw64.go
fi

##### syscall_linux_sw64.go

# Add method Msghdr.SetIovlen
if [ -n "$( grep -r "SetIovlen" ${WORK_DIR} )" ]; then
	warn "  syscall_linux_sw64.go: Add method Msghdr.SetIovlen"
	cat ${FILE_DIR}/SetIovlen.go >> ${WORK_DIR}/syscall_linux_sw64.go
fi

# Add function Pipe2
if [ -n "$( grep "func Pipe2" ${WORK_DIR}/syscall_linux_*.go )" ]; then
	warn "  syscall_linux_sw64.go: Add function Pipe2"
	cat ${FILE_DIR}/Pipe2.go >> ${WORK_DIR}/syscall_linux_sw64.go
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

#info "Remove all common consts, funcs, and types from (ztypes|zsyscall|zerrors)_linux_sw64.go ..."

#for i in ztypes zerrors zsyscall; do
#	if [ -f ${WORK_DIR}/${i}_linux.go ]; then
#		warn "  ${i}_linux_sw64.go"
#		cp ${WORK_DIR}/${i}_linux.go ${WORK_DIR}/${i}_linux_generic.go
#		${BASH_DIR}/mkmerge -out /tmp/${i}_linux.go ${WORK_DIR}/${i}_linux_generic.go ${WORK_DIR}/${i}_linux_sw64.go
#        cp ${WORK_DIR}/${i}_linux.go ${WORK_DIR}/${i}_linux_generic.go
#        ${BASH_DIR}/mkmerge -out /tmp/${i}_linux.go ${WORK_DIR}/${i}_linux_generic.go ${WORK_DIR}/zerrors_linux_sw64.go
#		rm /tmp/${i}_linux.go ${WORK_DIR}/${i}_linux_generic.go
#	fi
#done

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
