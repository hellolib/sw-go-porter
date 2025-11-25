#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/config.go ]; then
info "Processing: config.go"
[ -z "$( grep "sw64" ${WORK_DIR}/config.go )" ] && \
	sed -i "/AARCH64/a\\\t\"SCMP_ARCH_SW_64\":       \"sw64\"," ${WORK_DIR}/config.go
success "Done."
fi
