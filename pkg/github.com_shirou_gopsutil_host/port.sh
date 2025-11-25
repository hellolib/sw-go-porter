#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



info "Creating: host_linux_sw64.go"
cp -f ${BASH_DIR}/host_linux_sw64.go ${WORK_DIR}/host_linux_sw64.go
success "Done."



#if [ -f ${WORK_DIR}/host_linux.go ]; then
#info "Processing: host_linux.go"
# TODO: Add Deepin, UOS, Kylin and openEuler distro
#success "Done."
#fi
