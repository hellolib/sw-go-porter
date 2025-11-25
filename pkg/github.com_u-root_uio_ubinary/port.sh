#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/little_endian.go ]; then
info "Processing: little_endian.go"
sed -i "s@:build 386@:build sw64 \|\| 386@" ${WORK_DIR}/little_endian.go
sed -i "s@+build 386@+build sw64 386@" ${WORK_DIR}/little_endian.go
success "Done."
fi
