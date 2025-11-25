#!/bin/bash

# Added since Golang 1.9

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/msghdr_linux_64bit.go ]; then
info "Processing: msghdr_linux_64bit.go"
sed -i "s@:build (arm64@:build (sw64 \|\| arm64@" ${WORK_DIR}/msghdr_linux_64bit.go
sed -i "s@+build arm64@+build sw64 arm64@" ${WORK_DIR}/msghdr_linux_64bit.go
success "Done."
fi



if [ -f ${WORK_DIR}/cmsghdr_linux_64bit.go ]; then
info "Processing: cmsghdr_linux_64bit.go"
sed -i "s@:build (arm64@:build (sw64 \|\| arm64@" ${WORK_DIR}/cmsghdr_linux_64bit.go
sed -i "s@+build arm64@+build sw64 arm64@" ${WORK_DIR}/cmsghdr_linux_64bit.go
success "Done."
fi



if [ -f ${WORK_DIR}/iovec_64bit.go ]; then
info "Processing: iovec_64bit.go"
sed -i "s@:build (arm64@:build (sw64 \|\| arm64@" ${WORK_DIR}/iovec_64bit.go
sed -i "s@+build arm64@+build sw64 arm64@" ${WORK_DIR}/iovec_64bit.go
success "Done."
fi



info "Creating: sys_linux_sw64.go"
[ -f ${WORK_DIR}/sys_linux_riscv64.go ] && cp -f ${WORK_DIR}/sys_linux_riscv64.go ${WORK_DIR}/sys_linux_sw64.go
[ ! -f ${WORK_DIR}/sys_linux_sw64.go ] && cp -f ${WORK_DIR}/sys_linux_mips64le.go ${WORK_DIR}/sys_linux_sw64.go
sed -i "s@riscv64@sw64@g" ${WORK_DIR}/sys_linux_sw64.go
sed -i "s@mips64le@sw64@g" ${WORK_DIR}/sys_linux_sw64.go
sed -i "s@sysRECVMMSG = [0-9a-z]*@sysRECVMMSG = 0x1df@" ${WORK_DIR}/sys_linux_sw64.go
sed -i "s@sysSENDMMSG = [0-9a-z]*@sysSENDMMSG = 0x1f7@" ${WORK_DIR}/sys_linux_sw64.go
success "Done."



info "Creating: zsys_linux_sw64.go"
[ -f ${WORK_DIR}/zsys_linux_riscv64.go ] && cp -f ${WORK_DIR}/zsys_linux_riscv64.go ${WORK_DIR}/zsys_linux_sw64.go
[ ! -f ${WORK_DIR}/zsys_linux_sw64.go ] && cp -f ${WORK_DIR}/zsys_linux_mips64le.go ${WORK_DIR}/zsys_linux_sw64.go
sed -i "s@riscv64@sw64@g" ${WORK_DIR}/zsys_linux_sw64.go
sed -i "s@mips64le@sw64@g" ${WORK_DIR}/zsys_linux_sw64.go
# Struct msghdr has no member named Pad_cgo_1 on sw64
# See: $(go env GOROOT)/src/syscall/ztypes_linux_sw64.go
if [ -n "$( grep "Pad_cgo_1" ${WORK_DIR}/zsys_linux_sw64.go)" ]; then
	sed -i "/Pad_cgo_0/d" ${WORK_DIR}/zsys_linux_sw64.go
	sed -i "s@Pad_cgo_1@Pad_cgo_0@" ${WORK_DIR}/zsys_linux_sw64.go
fi
success "Done."
