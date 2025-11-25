#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/syscall_linux_64.go ]; then
info "Processing: syscall_linux_64.go"
sed -i "s@+build linux,arm64@+build linux,sw64 linux,arm64@" ${WORK_DIR}/syscall_linux_64.go
sed -i "s@(arm64@(sw64 \|\| arm64@" ${WORK_DIR}/syscall_linux_64.go
sed -i "s@+build arm64@+build sw64 arm64@" ${WORK_DIR}/syscall_linux_64.go
success "Done."
fi



if [ -f ${WORK_DIR}/setns_linux.go ]; then
info "Processing: setns_linux.go"
[ -z "$( grep "sw64" ${WORK_DIR}/setns_linux.go )" ] && \
	sed -i "/s390x/a\\\t\"linux/sw64\":    501," ${WORK_DIR}/setns_linux.go
success "Done."
fi
