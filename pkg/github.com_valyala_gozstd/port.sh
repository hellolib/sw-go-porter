#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/libzstd_linux.a ]; then
	info "Processing: libzstd_linux.a"
	[ ! -f ${WORK_DIR}/libzstd_linux.a.amd64 ] && mv ${WORK_DIR}/libzstd_linux.a ${WORK_DIR}/libzstd_linux.a.amd64
	cp -f ${BASH_DIR}/libzstd_linux.a ${WORK_DIR}/libzstd_linux.a
else
	info "Creating: libzstd_linux_sw64.a and libzstd_linux_sw64.go"
	cp -f ${BASH_DIR}/libzstd_linux_sw64.* ${WORK_DIR}
fi
success "Done."
