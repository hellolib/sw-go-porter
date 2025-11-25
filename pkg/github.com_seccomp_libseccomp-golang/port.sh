#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/seccomp.go ]; then
info "Processing: seccomp.go"
if [ -z "$( grep "SW64" ${WORK_DIR}/seccomp.go )" ]; then
	if [ -n "$( grep "ArchARM64 ScmpArch" ${WORK_DIR}/seccomp.go )" ]; then
		# ArchSW64 ScmpArch = iota
		sed -i "/ArchARM64 ScmpArch/a\\\t\/\/ ArchSW64 represents 64-bit sw_64 syscalls\n\tArchSW64 ScmpArch = iota" ${WORK_DIR}/seccomp.go
	else
		# ArchSW64
		sed -i "/ArchARM64$/a\\\t\/\/ArchSW64 represents 64-bit sw_64 syscalls\n\tArchSW64" ${WORK_DIR}/seccomp.go 
	fi

	# case "sw64", "sw_64":
	#     return ArchSW64, nil
	sed -i "/ArchARM64, nil/a\\\tcase \"sw64\", \"sw_64\":\n\t\treturn ArchSW64, nil" ${WORK_DIR}/seccomp.go

	# case ArchSW64:
	#     return "sw64"
	sed -i "/return \"arm64\"/a\\\tcase ArchSW64:\n\t\treturn \"sw64\"" ${WORK_DIR}/seccomp.go
fi
success "Done."
fi



if [ -f ${WORK_DIR}/seccomp_internal.go ]; then
info "Processing: seccomp_internal.go"
if [ -z "$( grep "SW_64" ${WORK_DIR}/seccomp_internal.go )" ]; then
	# #ifndef SCMP_ARCH_SW_64
	# #define SCMP_ARCH_SW_64 ARCH_BAD
	# #endif
	sed -i "/C_ARCH_BAD = ARCH_BAD;/a\\\n#ifndef SCMP_ARCH_SW_64\n#define SCMP_ARCH_SW_64 ARCH_BAD\n#endif" ${WORK_DIR}/seccomp_internal.go

	# const uint32_t C_ARCH_SW_64        = SCMP_ARCH_SW_64;
	sed -i "/SCMP_ARCH_AARCH64;/a\\const uint32_t C_ARCH_SW_64        = SCMP_ARCH_SW_64;" ${WORK_DIR}/seccomp_internal.go

	# case C.C_ARCH_SW_64:
	#     return ArchSW64, nil
	sed -i "/return ArchARM64, nil/a\\\tcase C.C_ARCH_SW_64:\n\t\treturn ArchSW64, nil" ${WORK_DIR}/seccomp_internal.go

	# case ArchSW64:
	#     return C.C_ARCH_SW_64
	sed -i "/return C.C_ARCH_AARCH64/a\\\tcase ArchSW64:\n\t\treturn C.C_ARCH_SW_64" ${WORK_DIR}/seccomp_internal.go
fi
success "Done."
fi
