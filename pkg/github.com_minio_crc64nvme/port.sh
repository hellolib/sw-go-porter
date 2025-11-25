#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/crc64_other.go ]; then
info "Processing: crc64_other.go"
# Fix non-asm builds
# https://github.com/minio/crc64nvme/commit/0a53153041b96db22da97cd5a39090ec49ff8deb
if [ -z "$( grep "func updateAsm(" ${WORK_DIR}/crc64_other.go )" ]; then
	echo -e "\nfunc updateAsm(crc uint64, p []byte) (checksum uint64) { panic(\"should not be reached\") }" >> ${WORK_DIR}/crc64_other.go
fi
success "Done."
fi
