#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/sys_linux_amd64.go ]; then
info "Creating: sys_linux_sw64.go"
[ -n "$( grep "sysGetsockopt" ${WORK_DIR}/sys_linux_amd64.go)" ] && cp -f ${BASH_DIR}/sys_linux_sw64_v1.go ${WORK_DIR}/sys_linux_sw64.go
[ -n "$( grep "sysGETSOCKOPT" ${WORK_DIR}/sys_linux_amd64.go)" ] && cp -f ${BASH_DIR}/sys_linux_sw64_v2.go ${WORK_DIR}/sys_linux_sw64.go
[ -n "$( grep "sysSIOCINQ"    ${WORK_DIR}/sys_linux_amd64.go)" ] && cp -f ${BASH_DIR}/sys_linux_sw64_v3.go ${WORK_DIR}/sys_linux_sw64.go
success "Done."
fi
