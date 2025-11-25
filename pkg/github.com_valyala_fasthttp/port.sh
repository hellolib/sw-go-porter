#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



FILES_32="bytesconv_32.go bytesconv_32_test.go round2_32.go round2_32_test.go"
FILES_64="bytesconv_64.go bytesconv_64_test.go round2_64.go round2_64_test.go"

for f in ${FILES_32}; do
	if [ -f ${WORK_DIR}/$f ]; then
	info "Processing: $f"
	sed -i "s@:build \!amd64@:build \!sw64 \&\& \!amd64@" ${WORK_DIR}/$f
	sed -i "s@+build \!amd64@+build \!sw64,\!amd64@" ${WORK_DIR}/$f
	success "Done."
	fi
done

for f in ${FILES_64}; do
	if [ -f ${WORK_DIR}/$f ]; then
	info "Processing: $f"
	sed -i "s@:build amd64@:build sw64 \|\| amd64@" ${WORK_DIR}/$f
	sed -i "s@+build amd64@+build sw64 amd64@" ${WORK_DIR}/$f
	success "Done."
	fi
done
