#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/endian_generic.go ]; then
info "Processing: endian_generic.go"
sed -i "s@:build \!mips@:build \!sw64 \&\& \!mips@" ${WORK_DIR}/endian_generic.go
sed -i "s@+build \!mips@+build \!sw64,\!mips@" ${WORK_DIR}/endian_generic.go
success "Done."
fi



if [ -f ${WORK_DIR}/endian_little.go ]; then
info "Processing: endian_little.go"
sed -i "s@:build amd64@:build sw64 \|\| amd64@" ${WORK_DIR}/endian_little.go
sed -i "s@+build amd64@+build sw64 amd64@" ${WORK_DIR}/endian_little.go
success "Done."
fi
