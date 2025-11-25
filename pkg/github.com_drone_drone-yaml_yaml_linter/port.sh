#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/linter.go ]; then
info "Processing: linter.go"
if [ -z "$( grep "sw64" ${WORK_DIR}/linter.go )" ]; then
	[ -z "$( grep "s390x" ${WORK_DIR}/linter.go )" ] && sed -i "/amd64/a\\\t\"sw64\":  struct{}{}," ${WORK_DIR}/linter.go
	[ -n "$( grep "s390x" ${WORK_DIR}/linter.go )" ] && sed -i "/s390x/a\\\t\"sw64\":    struct{}{}," ${WORK_DIR}/linter.go
fi
success "Done."
fi
