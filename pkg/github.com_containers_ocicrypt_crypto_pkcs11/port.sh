#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/utils.go ]; then
info "Processing: utils.go"
[ -z "$( grep "sw64" ${WORK_DIR}/utils.go )" ] && \
	sed -i "/ht = \"s390x\"/a\\\t\tcase \"sw64\":\n\t\t\tht = \"sw64\"" ${WORK_DIR}/utils.go
success "Done."
fi
