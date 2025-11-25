#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ ! -f ${WORK_DIR}/signal_linux.go ]; then
  info "signal_linux.go not found, the package may be deprecated."
  warn "Skipped."
  exit 0;
fi

# SIGSTKFLT does not exist on sw64, instead SIGEMT and SIGINFO do.
if [ ! -f ${WORK_DIR}/signal_linux_sw64.go ]; then
  info "Creating: signal_linux_sw64.go"
  cp -f ${WORK_DIR}/signal_linux.go ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/!mips/d' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '1 i\//go:build linux && sw64\n// +build linux\n// +build sw64\n' ${WORK_DIR}/signal_linux_sw64.go
  # Remove SIGSTKFLT
  sed -i '/STKFLT/d' ${WORK_DIR}/signal_linux_sw64.go
  # Add SIGEMT
  sed -i '/^\tsyscall.SIGCONT,/ a\\tsyscall.SIGEMT,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t\tsyscall.SIGCONT,/ a\\t\tsyscall.SIGEMT,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t"CONT":\s*syscall.SIGCONT,/ a\\t"EMT":      syscall.SIGEMT,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t"CONT":\s*unix.SIGCONT,/ a\\t"EMT":      unix.SIGEMT,' ${WORK_DIR}/signal_linux_sw64.go
  # Add SIGINFO
  sed -i '/^\tsyscall.SIGILL,/ a\\tsyscall.SIGINFO,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t\tsyscall.SIGILL,/ a\\t\tsyscall.SIGINFO,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t"ILL":\s*syscall.SIGILL,/ a\\t"INFO":     syscall.SIGINFO,' ${WORK_DIR}/signal_linux_sw64.go
  sed -i '/^\t"ILL":\s*unix.SIGILL,/ a\\t"INFO":     unix.SIGINFO,' ${WORK_DIR}/signal_linux_sw64.go
  success "Done."
fi



if [ -f ${WORK_DIR}/signal_linux.go ]; then
  info "Processing: signal_linux.go"
  if [ -z "$( grep "sw64" ${WORK_DIR}/signal_linux.go)" ]; then
    if [ ! -f ${WORK_DIR}/signal_linux_mipsx.go ]; then
      sed -i "1 i\//go:build \!sw64\n// +build \!sw64\n" ${WORK_DIR}/signal_linux.go
    else
      sed -i "s@+build \!mips@+build \!sw64,\!mips@" ${WORK_DIR}/signal_linux.go
      sed -i "s@:build \!mips@:build \!sw64 \&\& \!mips@" ${WORK_DIR}/signal_linux.go
    fi
  fi
  success "Done."
fi
