#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/arch.go ]; then
info "Processing: arch.go"
if [ -z "$( grep "sw64" ${WORK_DIR}/arch.go )" ]; then
	if [ -n "$( grep "RISCV64" ${WORK_DIR}/arch.go )" ]; then
		sed -i "/hdrArchRISCV64  archType/a\\\thdrArchSW64     archType = [...]byte{'1', '3', '\\\\x00'}" ${WORK_DIR}/arch.go
		sed -i "/\"riscv64\":  hdrArchRISCV64,/a\\\t\t\"sw64\":     hdrArchSW64," ${WORK_DIR}/arch.go
		sed -i "/hdrArchRISCV64:  \"riscv64\",/a\\\t\thdrArchSW64:     \"sw64\"," ${WORK_DIR}/arch.go
	else
		sed -i "/hdrArchS390x    archType/a\\\thdrArchSW64     archType = [...]byte{'1', '2', '\\\\x00'}" ${WORK_DIR}/arch.go
		sed -i "/\"s390x\":    hdrArchS390x,/a\\\t\t\"sw64\":     hdrArchSW64," ${WORK_DIR}/arch.go
		sed -i "/hdrArchS390x:    \"s390x\",/a\\\t\thdrArchSW64:     \"sw64\"," ${WORK_DIR}/arch.go
	fi
fi
success "Done."
fi



if [ -f ${WORK_DIR}/lookup.go ]; then
info "Processing: lookup.go"
if [ -z "$( grep "sw64" ${WORK_DIR}/lookup.go )" ]; then
	sed -i "/\"s390x\":    HdrArchS390x,/a\\\t\t\"sw64\":     hdrArchSW64," ${WORK_DIR}/lookup.go
	sed -i "/HdrArchS390x:    \"s390x\",/a\\\t\thdrArchSW64:     \"sw64\"," ${WORK_DIR}/lookup.go
fi
success "Done."
fi



if [ -f ${WORK_DIR}/sif.go ]; then
info "Processing: sif.go"
[ -z "$( grep "sw64" ${WORK_DIR}/sif.go )" ] && \
	sed -i "/HdrArchS390x/a\\\tHdrArchSW64     = \"12\" // SW64 arch code" ${WORK_DIR}/sif.go
success "Done."
fi
