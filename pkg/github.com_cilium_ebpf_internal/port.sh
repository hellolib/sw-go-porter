#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/endian_le.go ]; then
  info "Processing: endian_le.go"
  sed -i "s@+build 386@+build sw64 386@" ${WORK_DIR}/endian_le.go
  sed -i "s@:build 386@:build sw64 \|\| 386@" ${WORK_DIR}/endian_le.go
  success "Done."
fi
