#!/bin/bash
# Resolves in which directory is this file located so it does not matter from which path it is being called
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Sets the branch name to use as the current date and time
BRANCH_NAME=$(date +"%Y-%m-%d-%H%M")
FROM_UPSTREAM=$1
if [ -z "$FROM_UPSTREAM" ]; then
    echo "The first and only argument must be the remote upstream from which you want to update this deployment repository."
    exit 1
fi

CALL_DIR=$(pwd)
echo $(pwd)
cd $DIR
echo $(pwd)

return_to_origin_dir(){
    cd $CALL_DIR
    echo $(pwd)
}

check_last_call(){
    rc=$?; 
    if [[ $rc != 0 ]]; then 
        echo "---------->ERROR: STEP FAILED!"
        return_to_origin_dir
        exit $rc; 
    fi
}

CURRENT_STEP=1
run_step(){
    echo "Step ${CURRENT_STEP}: ----------> $1"
    eval $1
    check_last_call
    let "CURRENT_STEP++"
}

run_step "git checkout master"
run_step "git pull"
run_step "git checkout -b ${BRANCH_NAME}"
run_step "git pull ${FROM_UPSTREAM} master"
run_step "git push --set-upstream origin ${BRANCH_NAME}"
run_step "git checkout master"
run_step "git branch -d ${BRANCH_NAME}"
return_to_origin_dir
