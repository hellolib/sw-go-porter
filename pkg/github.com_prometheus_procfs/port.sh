#!/bin/bash

set -e

[ $# -lt 1 ] && echo "Empty input" && exit 1
[ -z $1 ] || [ ! -d $1 ] && echo "Invalid input" && exit 1

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )

source ${BASH_DIR}/../../common.sh



if [ -f ${WORK_DIR}/cpuinfo_others.go ]; then
info "Processing: cpuinfo_others.go"
sed -i "s@,\!s390x\$@,\!s390x,\!sw64@" ${WORK_DIR}/cpuinfo_others.go
sed -i "s@\&\& \!s390x\$@\&\& \!s390x \&\& \!sw64@" ${WORK_DIR}/cpuinfo_others.go
success "Done."
fi



if [ -f ${WORK_DIR}/cpuinfo_armx.go -o -f ${WORK_DIR}/cpuinfo_arm64.go ]; then
info "Creating: cpuinfo_sw64.go"
cp -f ${BASH_DIR}/cpuinfo_sw64.go ${WORK_DIR}/cpuinfo_sw64.go
success "Done."
fi



if [ -f ${WORK_DIR}/cpuinfo.go ]; then
info "Processing: cpuinfo.go"
if [ -n "$( grep "parseCPUInfoX86" ${WORK_DIR}/cpuinfo.go )" -a -z "$( grep "parseCPUInfoSW64" ${WORK_DIR}/cpuinfo.go )" ]; then
	echo >> ${WORK_DIR}/cpuinfo.go
	if [ -n "$( grep "fmt" ${WORK_DIR}/cpuinfo.go)" ]; then
	cat ${BASH_DIR}/parseCPUInfoSW64.go >> ${WORK_DIR}/cpuinfo.go  
	else
	cat ${BASH_DIR}/parseCPUInfoSW64.go | sed "s@fmt.Errorf(\"invalid cpuinfo file: %q\", firstLine)@errors.New(\"invalid cpuinfo file: \" + firstLine)@" >> ${WORK_DIR}/cpuinfo.go  
	fi
fi
success "Done."
fi



# https://github.com/prometheus/procfs/pull/547
if [ -f ${WORK_DIR}/stat.go ]; then
info "Fixing: stat.go"
if [ -z "$( grep "Increase default scanner buffer" ${WORK_DIR}/stat.go )" ]; then
    sed -i '/scanner.Scan()/ i\\t// Increase default scanner buffer to handle very long `intr` lines.\n\tbuf := make([]byte, 0, 8*1024)\n\tscanner.Buffer(buf, 1024*1024)\n' ${WORK_DIR}/stat.go
fi
success "Done."
fi
