#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/kernel_utsname_int8.go ]; then
info "Processing: kernel_utsname_int8.go"
# 2023-12-19 Rong: See defination of `Utsname` in $(go env GOROOT)/src/syscall/ztypes_linux_sw64.go
sed -i "s@:build (linux \&\& 386)@:build (linux \&\& sw64) \|\| (linux \&\& 386)@" ${WORK_DIR}/kernel_utsname_int8.go
sed -i "s@+build linux,386@+build linux,sw64 linux,386@" ${WORK_DIR}/kernel_utsname_int8.go
success "Done."
fi
