#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/completion.go ]; then
info "Processing: completion.go"
if [ -z "$( grep "sw64" ${WORK_DIR}/completion.go )" ]; then
	sed -i "/\"linux\/s390x\",/a\\\t\t\"linux\/sw64\"," ${WORK_DIR}/completion.go
	sed -i "/\"s390x\",/a\\\t\t\"sw64\"," ${WORK_DIR}/completion.go
fi
success "Done."
fi

