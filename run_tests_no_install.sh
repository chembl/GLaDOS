#!/bin/bash
# Resolves in which directory is this file located so it does not matter from which path it is being called
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ ${SOURCE} != /* ]] && SOURCE="$DIR/$SOURCE"
done
export DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# THIS CODE WILL BE USEFUL WHEN TRAVIS/FIREFOX/SELENIUM BECOMES STABLE!
#export GECKO_BIN_DIR=${DIR}/gecko_bin
#export GECKO_DRIVER_PATH=${GECKO_BIN_DIR}/geckodriver
#
#if [ -f ${GECKO_DRIVER_PATH} ]; then
#    printf "geckodriver found in ${GECKO_DRIVER_PATH} no need to download it again!\n"
#else
#    mkdir -p ${GECKO_BIN_DIR}
#    GECKO_URL="https://github.com/mozilla/geckodriver/releases/download/v0.13.0/"
#    GECKO_ZIP=${GECKO_BIN_DIR}/geckodriver.tar.gz
#    MAC_OS_PATH="geckodriver-v0.13.0-macos.tar.gz"
#    LINUX64_PATH="geckodriver-v0.13.0-linux64.tar.gz"
#    if [ "$(uname)" == "Darwin" ]; then
#        # Do something under Mac OS X platform
#        GECKO_URL=${GECKO_URL}${MAC_OS_PATH}
#        printf "MAC OS Detected, using: ${GECKO_URL}\n"
#    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
#        # Do something under GNU/Linux platform
#        GECKO_URL=${GECKO_URL}${LINUX64_PATH}
#        printf "Linux Detected, using: ${GECKO_URL}\n"
#    else
#        printf "Unsupported uname:$(uname)\n" 1>&2
#        printf "Please install geckodriver and run test manually with selenium+firefox\n" 1>&2
#        exit 1
#    fi
#    curl -o ${GECKO_ZIP} -L ${GECKO_URL}
#    # if last command failed exits
#    rc=$?; if [[ ${rc} != 0 ]]; then exit ${rc}; fi
#    tar -xzf ${GECKO_ZIP} -C ${GECKO_BIN_DIR}
#    # if last command failed exits
#    rc=$?; if [[ ${rc} != 0 ]]; then exit ${rc}; fi
#fi
#export PATH=${GECKO_BIN_DIR}:$PATH
#echo "PATH:$PATH"

export PYTHONPATH=${DIR}/src:${PYTHONPATH}
echo "PYTHONPATH:$PYTHONPATH"
python -m glados.tests.run_tests test
rc=$?; if [[ ${rc} != 0 ]]; then exit ${rc}; fi