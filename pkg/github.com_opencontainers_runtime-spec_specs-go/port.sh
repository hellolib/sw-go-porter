#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/config.go ]; then
info "Processing: config.go"
# 2023-12-20 Rong: See /usr/include/seccomp.h
[ -z "$( grep "SW_64" ${WORK_DIR}/config.go )" ] && \
	sed -i "/ArchX32/a\\\tArchSW_64       Arch = \"SCMP_ARCH_SW_64\"" ${WORK_DIR}/config.go
success "Done."
fi
