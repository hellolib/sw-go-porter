#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



info "Creating: bolt_sw64.go"
cp -f ${BASH_DIR}/bolt_sw64.go ${WORK_DIR}/bolt_sw64.go
[ -n "$( grep "brokenUnaligned" ${WORK_DIR}/bolt_amd64.go )" ] && \
	echo -e "\n// Are unaligned load/stores broken on this arch?\nvar brokenUnaligned = false" >> ${WORK_DIR}/bolt_sw64.go
[ -z "$( grep "bbolt" ${WORK_DIR}/bolt_amd64.go)" ] && \
	sed -i "s@bbolt@bolt@" ${WORK_DIR}/bolt_sw64.go
success "Done."
