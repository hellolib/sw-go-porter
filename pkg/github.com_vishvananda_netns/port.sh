#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/netns_linux.go ]; then
info "Processing: netns_linux.go"
# 2023-12-20 Rong: `printf SYS_setns | gcc -include sys/syscall.h -E - | tail -n 1`
[ -z "$( grep "sw64" ${WORK_DIR}/netns_linux.go )" ] && \
	sed -i "/s390x/a\\\t\"sw64\":    501," ${WORK_DIR}/netns_linux.go
success "Done."
fi



# 2025-02-27 Rong: netns_linux_*.go files exists before 2015-09-16
# https://github.com/vishvananda/netns/commit/3e1d42c9bcf094d5f9f424e3d862535818959362
if [ -f ${WORK_DIR}/netns_linux_386.go ]; then
info "Creating: netns_linux_sw64.go"
cp -f ${BASH_DIR}/netns_linux_sw64.go ${WORK_DIR}/netns_linux_sw64.go
success "Done."
fi
