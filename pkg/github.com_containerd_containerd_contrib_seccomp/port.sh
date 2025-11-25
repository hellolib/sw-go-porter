#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/seccomp_default.go ]; then
info "Processing: seccomp_default.go"
[ -z "$( grep "sw64" ${WORK_DIR}/seccomp_default.go )" ] && \
	sed -i "/ArchS390/a\\\tcase \"sw64\":\n\t\treturn []specs.Arch{specs.ArchSW_64}" ${WORK_DIR}/seccomp_default.go && \
	sed -i "/\"mount\",/a\\\t\t\t\t\t\"osf_mount\"," ${WORK_DIR}/seccomp_default.go && \
	sed -i "/\"settimeofday\",/a\\\t\t\t\t\t\"osf_settimeofday\"," ${WORK_DIR}/seccomp_default.go && \
	${BASH_DIR}/generate.sh ${WORK_DIR}
success "Done."
fi
