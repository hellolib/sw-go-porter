#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/rawalloc_64bit.go ]; then
info "Processing: rawalloc_64bit.go"
sed -i "s@go:build amd64@go:build sw64 \|\| amd64@" ${WORK_DIR}/rawalloc_64bit.go
sed -i "s@+build amd64@+build sw64 amd64@" ${WORK_DIR}/rawalloc_64bit.go
success "Done."
fi
