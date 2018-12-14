#!/bin/bash -ex
# Resolves in which directory is this file located so it does not matter from which path it is being called
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ ${SOURCE} != /* ]] && SOURCE="$DIR/$SOURCE"
done
export DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

export PYTHONPATH=${DIR}/src:${PYTHONPATH}
echo "PYTHONPATH:$PYTHONPATH"
python -m glados.tests.run_tests
rc=$?; if [[ ${rc} != 0 ]]; then exit ${rc}; fi