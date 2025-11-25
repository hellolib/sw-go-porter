#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh

info "Creating: zsys_linux_sw64.go"
[ -f ${WORK_DIR}/zsys_linux_riscv64.go ] && cp -f ${WORK_DIR}/zsys_linux_riscv64.go ${WORK_DIR}/zsys_linux_sw64.go
[ ! -f ${WORK_DIR}/zsys_linux_sw64.go ] && cp -f ${WORK_DIR}/zsys_linux_mips64le.go ${WORK_DIR}/zsys_linux_sw64.go
sed -i "s@riscv64@sw64@g" ${WORK_DIR}/zsys_linux_sw64.go
sed -i "s@mips64le@sw64@g" ${WORK_DIR}/zsys_linux_sw64.go
success "Done."
