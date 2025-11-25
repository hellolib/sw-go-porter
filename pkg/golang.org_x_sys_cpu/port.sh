#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/byteorder.go ]; then
info "Processing: byteorder.go"
sed -i "s@\"sh\":@\"sh\",\n\t\t\"sw64\":@" ${WORK_DIR}/byteorder.go
success "Done."
fi



if [ -f ${WORK_DIR}/endian_little.go ]; then
info "Processing: endian_little.go"
sed -i "s@:build 386@:build sw64 \|\| 386@" ${WORK_DIR}/endian_little.go
sed -i "s@+build 386@+build sw64 386@" ${WORK_DIR}/endian_little.go
success "Done."
fi



info "Creating: cpu_sw64.go"
echo -e "//go:build sw64\n// +build sw64\n\npackage cpu\n\nconst cacheLineSize = 128" > ${WORK_DIR}/cpu_sw64.go
[ -n "$( grep "initOptions" ${WORK_DIR}/cpu_mips64x.go )" ] && echo -e "\nfunc initOptions() {}" >> ${WORK_DIR}/cpu_sw64.go
[ -n "$( grep "doinit" ${WORK_DIR}/cpu_mips64x.go )" ] && echo -e "\nfunc doinit() {}" >> ${WORK_DIR}/cpu_sw64.go
success "Done."
