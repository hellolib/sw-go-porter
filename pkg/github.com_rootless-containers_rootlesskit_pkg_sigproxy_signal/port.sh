#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/signal_linux.go ]; then
info "Processing: signal_linux.go"
sed -i "s@:build \!mips@:build \!sw64 \&\& \!mips@" ${WORK_DIR}/signal_linux.go
sed -i "s@+build \!mips@+build \!sw64,\!mips@" ${WORK_DIR}/signal_linux.go
success "Done."
fi



info "Creating: signal_linux_sw64.go"
# 2023-12-20 Rong: See $(go env GOROOT)/src/syscall/zerrors_linux_sw64.go and `kill -l`
cp -f ${BASH_DIR}/signal_linux_sw64.go ${WORK_DIR}/signal_linux_sw64.go
success "Done."
