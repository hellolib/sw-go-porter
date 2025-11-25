#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/enosys_linux.go ]; then
info "Processing: enosys_linux.go"
[ -z "$( grep "SW64" ${WORK_DIR}/enosys_linux.go )" ] && \
	# Be consistent with the definition in /usr/include/seccomp.h
	sed -i "/ AUDIT_ARCH_S390X/a#ifdef AUDIT_ARCH_SW_64\nconst uint32_t C_AUDIT_ARCH_SW_64        = AUDIT_ARCH_SW_64;\n#else\nconst uint32_t C_AUDIT_ARCH_SW_64        = AUDIT_ARCH_SW64;\n#endif" ${WORK_DIR}/enosys_linux.go && \
	# libseccomp: github.com/seccomp/libseccomp-golang
	sed -i "/C.C_AUDIT_ARCH_S390X/a\\\tcase libseccomp.ArchSW64:\n\t\treturn nativeArch(C.C_AUDIT_ARCH_SW_64), nil" ${WORK_DIR}/enosys_linux.go
	if [ -n "$( grep linuxAuditArch ${WORK_DIR}/enosys_linux.go )" ]; then sed -i "s@nativeArch@linuxAuditArch@" ${WORK_DIR}/enosys_linux.go; fi
success "Done."
fi
