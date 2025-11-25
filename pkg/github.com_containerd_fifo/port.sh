#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/handle_linux.go ]; then
info "Processing: handle_linux.go"
# 2023-12-18 Rong: O_PATH has different value on sw64 than on other architectures.
# Try: `printf O_PATH | gcc -include linux/fcntl.h -E - | tail -n 1`
sed -i "s@^const O_PATH@//const O_PATH@" ${WORK_DIR}/handle_linux.go
if [ -z "$( grep "sw64" ${WORK_DIR}/handle_linux.go)" ]; then
	PATTERN="func getHandle(fn string) (\*handle, error) {"
	sed -i "/${PATTERN}/a\\\tvar O_PATH = 010000000\n\tif runtime.GOARCH == \"sw64\" {\n\t\tO_PATH = 040000000\n\t}" ${WORK_DIR}/handle_linux.go 
	sed -i "/import (/a\\\t\"runtime\"" ${WORK_DIR}/handle_linux.go
fi
success "Done."
fi
