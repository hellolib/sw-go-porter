#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh


if [ -f ${WORK_DIR}/database.go ]; then
info "Processing: database.go"
sed -i "s@case \"386\"@case \"sw64\", \"386\"@" ${WORK_DIR}/database.go
success "Done."
fi
