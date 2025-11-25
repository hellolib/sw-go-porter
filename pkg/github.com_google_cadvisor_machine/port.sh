#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/machine.go ]; then
info "Processing: machine.go"
if [ -n "$( grep "isSystemZ" ${WORK_DIR}/machine.go)" -a -z "$( grep "SW_64" ${WORK_DIR}/machine.go )" ]; then
	if [ -n "$( grep "func isSystemZ()" ${WORK_DIR}/machine.go -A1 | grep getMachineArch )" ]; then
		cat ${BASH_DIR}/isSW_64.type1.go >> ${WORK_DIR}/machine.go
	else
		cat ${BASH_DIR}/isSW_64.type2.go >> ${WORK_DIR}/machine.go
	fi

	LINE=$( grep -n "func GetClockSpeed" ${WORK_DIR}/machine.go -A 500 | grep -m 1 "isSystemZ()" | cut -d'-' -f'1' )
	sed -i "${LINE}s@isSystemZ()@isSystemZ() || isSW_64()@" ${WORK_DIR}/machine.go
	sed -i "${LINE}s@true == isSystemZ() ||@true == isSystemZ() || true ==@" ${WORK_DIR}/machine.go
fi
success "Done."
fi
