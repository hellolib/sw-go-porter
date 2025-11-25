#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/atomic64.go ]; then
info "Processing: atomic64.go"
sed -i 's@s390x$@s390x sw64@' ${WORK_DIR}/atomic64.go
success "Done."
fi
