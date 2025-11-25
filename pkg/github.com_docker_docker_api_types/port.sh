#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/seccomp.go ]; then
info "Processing: seccomp.go"
# 2023-12-18 Rong: See /usr/include/seccomp.h
[ -z "$( grep "ArchSW_64" ${WORK_DIR}/seccomp.go )" ] && \
	sed -i "/ArchS390X/a\\\tArchSW_64       Arch = \"SCMP_ARCH_SW_64\"" ${WORK_DIR}/seccomp.go
success "Done."
fi
