#!/bin/bash

WORK_DIR=$1
BASH_DIR=$( cd $( dirname ${BASH_SOURCE[0]:-$0} ) && pwd )



# files to analyze
[ -f "/usr/include/asm/unistd_64.h" ] && UNIX_STD_FILE="/usr/include/asm/unistd_64.h"
[ -f "/usr/include/asm/unistd.h" ]    && UNIX_STD_FILE="/usr/include/asm/unistd.h ${UNIX_STD_FILE}"
UNIX_STD_FILE="${BASH_DIR}/unistd* ${UNIX_STD_FILE}"



# syscalls on sw_64
SYSCALLS_SW_64=$( grep -v "not implemented" ${UNIX_STD_FILE} | grep -o "__NR_[a-zA-Z0-9_]*" | sed "s/__NR_//g" | sort | uniq )

# syscalls in seccomp_default.go
SYSCALLS_DEFAULT=$( grep -v "case" ${WORK_DIR}/seccomp_default.go | grep -o -E "\{?\"[a-zA-Z0-9_]*\"\}?,$" | sed -E "s/\"|,|\{|\}//g" | sort | uniq )

# syscalls disabled
# https://docs.docker.com/engine/security/seccomp/#significant-syscalls-blocked-by-the-default-profile
# https://github.com/containers/common/blob/main/pkg/seccomp/seccomp.json
# https://man7.org/linux/man-pages/man2/syscalls.2.html
SYSCALLS_DISABLED="acct add_key bpf clock_adjtime clock_settime clone create_module delete_module finit_module get_kernel_syms get_mempolicy init_module ioperm iopl kcmp kexec_file_load kexec_load keyctl lookup_dcookie mbind mount move_pages name_to_handle_at nfsservctl open_by_handle_at perf_event_open personality pivot_root process_vm_readv process_vm_writev ptrace query_module quotactl reboot request_key set_mempolicy setns settimeofday stime swapon swapoff sysfs _sysctl umount umount2 unshare uselib userfaultfd ustat vm86 vm86old"
SYSCALLS_DISABLED="${SYSCALLS_DISABLED} bdflush migrate_pages pciconfig_iobase pciconfig_read pciconfig_write"
SYSCALLS_DISABLED="${SYSCALLS_DISABLED} oldumount osf_mount osf_settimeofday osf_swapon"

# syscalls not implemented ?
SYSCALLS_NIMPD="afs_syscall tuxcall vserver"

# syscalls to exclude
SYSCALLS_EXCLUDE="${SYSCALLS_DEFAULT} ${SYSCALLS_DISABLED} ${SYSCALLS_NIMPD}"

# syscalls to add
SYSCALLS_ADD=$( echo ${SYSCALLS_SW_64} ${SYSCALLS_EXCLUDE} ${SYSCALLS_EXCLUDE} | tr ' ' '\n' | sort | uniq -u )



# write to seccomp_default.go
LINE=$( grep -n "include by arch" ${WORK_DIR}/seccomp_default.go | cut -d':' -f'1' ) && \
LINE=$(( $LINE + 1 ))

content="\tcase \"sw64\":\n"
content="${content}\t\ts.Syscalls = append(s.Syscalls, specs.LinuxSyscall{\n"
content="${content}\t\t\tNames: []string{\n"
for i in ${SYSCALLS_ADD}; do content="${content}\t\t\t\t\"$i\",\n"; done
content="${content}\t\t\t},\n"
content="${content}\t\t\tAction: specs.ActAllow,\n"
content="${content}\t\t\tArgs:   []specs.LinuxSeccompArg{},\n"
content="${content}\t\t})"

sed -i "${LINE}a\\${content}" ${WORK_DIR}/seccomp_default.go
