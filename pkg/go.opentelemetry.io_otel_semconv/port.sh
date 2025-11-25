#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



VERSIONS="v1.4.0 v1.5.0 v1.6.0 v1.7.0 v1.8.0 v1.9.0 v1.10.0 v1.11.0 v1.12.0 v1.13.0 v1.14.0 v1.15.0 v1.16.0 v1.17.0 v1.18.0 v1.19.0 v1.20.0 v1.21.0 v1.22.0 v1.23.0 v1.24.0"

for VERSION in ${VERSIONS}; do
	if [ -f ${WORK_DIR}/${VERSION}/resource.go ]; then
		info "Processing: ${VERSION}/resource.go"
		[ -z "$( grep "sw64" ${WORK_DIR}/${VERSION}/resource.go )" ] && \
			sed -i "/HostArchX86/a\\\t\/\/ SW64\n\tHostArchSW64 = HostArchKey.String(\"sw64\")" ${WORK_DIR}/${VERSION}/resource.go
		success "Done."
	fi
done
