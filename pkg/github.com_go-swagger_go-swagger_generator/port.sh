#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/language.go ]; then
info "Processing: language.go"
[ -z "$( grep "sw64" ${WORK_DIR}/language.go )" ] && \
	sed -i "/sparc64/a\\\t\t\"sw64\":        true," ${WORK_DIR}/language.go
success "Done."
fi
