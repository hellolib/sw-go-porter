#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/serialization_littleendian.go ]; then
info "Processing: serialization_littleendian.go"
sed -i "s@:build (386@:build (sw64 \&\& \!appengine) \|\| (386@" ${WORK_DIR}/serialization_littleendian.go
sed -i "s@+build 386@+build sw64,\!appengine 386@" ${WORK_DIR}/serialization_littleendian.go
success "Done."
fi



if [ -f ${WORK_DIR}/serialization_generic.go ]; then
info "Processing: serialization_generic.go"
sed -i "s@(\!amd64@(\!sw64 \&\& \!amd64@" ${WORK_DIR}/serialization_generic.go
sed -i "s@+build \!amd64@+build \!sw64,\!amd64@" ${WORK_DIR}/serialization_generic.go
success "Done."
fi
