#!/bin/bash

#set -e

USAGE="
Usage: $0 <the root of the golang module to port>

Options:
  -v, --version  output version information and exit
  -h, --help     display this help and exit
"
[ -z "$1" ] && echo "${USAGE}" && exit 0

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
	BASH_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
	SOURCE=$(readlink "$SOURCE")
	[[ $SOURCE != /* ]] && SOURCE=$BASH_DIR/$SOURCE
done
BASH_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

VERSION="UNKNOWN"
[ -s ${BASH_DIR}/VERSION ] && VERSION=$( cat ${BASH_DIR}/VERSION )

case "$1" in
	"-v"|"--version") echo "sw-go-porter version: ${VERSION}" && exit 0 ;;
	"-h"|"--help")    echo "${USAGE}" && exit 0 ;;
	"-"*)             echo "unrecognized option '$1'" && exit 0 ;;
	*)                [ ! -d "$1" ] && echo "${USAGE}" && exit 0 ;;
esac

WORK_DIR=$( realpath $1 )
PKG_DIR=${BASH_DIR}/pkg
PKGS=$( ls ${PKG_DIR} )

source ${BASH_DIR}/common.sh

bold "======================================================================"
bold "Working in ${WORK_DIR}"
echo -n "Continue? [Y/n] " && read
if ! [[ "${REPLY}" =~ ^[Yy]$ || -z ${REPLY} ]]; then error "Exit." && exit 0; fi
echo

bold "======================================================================"
echo -n "Download vendor? [Y/n] " && read
if [[ "${REPLY}" =~ ^[Yy]$ || -z ${REPLY} ]]; then
	bold "Download vendor:"
	cd ${WORK_DIR}
	info "Downloading vendor to ${WORK_DIR} ..."
	GO111MODULE=on go mod vendor
	[ $? -ne 0 ] && error "Failed to download vendor." && exit 1
	success "${WORK_DIR}/vendor downloaded."
else
	warn "Skip downloading vendor."
fi
echo

bold "======================================================================"
bold "Start porting:"
for PKG in ${PKGS}; do
	PKG_PATH=$( echo $PKG | sed "s@_@/@g" )
	PKG_PATH_REAL="${WORK_DIR}/vendor/${PKG_PATH}"
	if [ -d ${PKG_PATH_REAL} ]; then
		head "Porting ${PKG_PATH_REAL}"
		${PKG_DIR}/${PKG}/port.sh ${PKG_PATH_REAL}
		PORTED="${PORTED} ${PKG_PATH_REAL}"
	fi
done
echo

bold "======================================================================"
bold "Summary"
bold "----------------------------------------------------------------------"

bold "Packages ported:"
for i in ${PORTED}; do bold $i; done
echo

# Print something important

IMP_TXT=()

if [ -d ${WORK_DIR}/vendor/github.com/agiledragon/gomonkey/v2 ]; then
	IMP_TXT+=("For gomonkey (github.com/agiledragon/gomonkey/v2) to work properly, SW Golang 1.22 or higher is needed.")
fi

if [ ${#IMP_TXT[@]} -ne 0 ]; then
	bold "======================================================================"
	bold "!!! IMPORTANT !!!"
	bold "----------------------------------------------------------------------"
	for TXT in "${IMP_TXT[@]}"; do warn "${TXT}"; done
	echo
fi
