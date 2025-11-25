#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/state.go ]; then
info "Processing: state.go"
if [ -z "$( grep "sw64" ${WORK_DIR}/state.go )" ]; then
	if [ -z "$( grep "ocispecs" ${WORK_DIR}/state.go )" ]; then
		sed -i "/ppc64le/a\\\tLinuxSw64    = Platform(specs.Platform{OS: \"linux\", Architecture: \"sw64\"})" ${WORK_DIR}/state.go
	else
		sed -i "/ppc64le/a\\\tLinuxSw64    = Platform(ocispecs.Platform{OS: \"linux\", Architecture: \"sw64\"})" ${WORK_DIR}/state.go
	fi
fi
success "Done."
fi
