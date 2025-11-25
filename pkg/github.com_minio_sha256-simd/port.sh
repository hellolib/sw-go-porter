#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/cpuid_other.go ]; then
info "Processing: cpuid_other.go"
[ -z "$( grep "sw64" ${WORK_DIR}/sha256block_other.go )" ] && \
	sed -i "s@ppc64@sw64 ppc64@" ${WORK_DIR}/cpuid_other.go
success "Done."
fi



if [ -f ${WORK_DIR}/sha256block_other.go ]; then
info "Processing: sha256block_other.go"
[ -z "$( grep "sw64" ${WORK_DIR}/sha256block_other.go )" ] && \
	sed -i "s@ppc64@sw64 ppc64@" ${WORK_DIR}/sha256block_other.go
success "Done."
fi



if [ -f ${WORK_DIR}/cpuid_ppc64le.go ]; then
info "Creating: cpuid_sw64.go"
cp -f ${WORK_DIR}/cpuid_ppc64le.go ${WORK_DIR}/cpuid_sw64.go
success "Done."
fi



if [ -f ${WORK_DIR}/sha256block_ppc64le.go ]; then
info "Creating: sha256block_sw64.go"
cp -f ${WORK_DIR}/sha256block_ppc64le.go ${WORK_DIR}/sha256block_sw64.go
success "Done."
fi
