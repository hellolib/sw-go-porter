#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/clone.go ]; then
info "Processing: clone.go"
[ -z "$( grep "sw64" ${WORK_DIR}/clone.go )" ] && \
	sed -i "/return \"drone\/git:linux-arm64\"/a\\\tcase src.Platform.OS == \"linux\" \&\& src.Platform.Arch == \"sw64\":\n\t\treturn \"drone\/git:linux-sw64\"" ${WORK_DIR}/clone.go
success "Done."
fi
