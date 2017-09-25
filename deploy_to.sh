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
TAG_NAME=$(date +"%Y-%m-%d-%H%M")
TO_UPSTREAM=$1
if [ -z "$TO_UPSTREAM" ]; then
    echo "The first and only argument must be the remote upstream to which you want to deploy."
    exit 1
fi

return_to_origin_dir(){
    if [ -n "$CALL_DIR" ]
    then
        echo "Returning to $CALL_DIR . . ."
        cd $CALL_DIR
        echo "Current location: $(pwd)"
    fi
    if [ -n "$TEMP_DIR" ]
    then
        echo "Deleting temporary directory at: $TEMP_DIR"
        rm -rf $TEMP_DIR
    fi
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
    printf "\nStep ${CURRENT_STEP}: ----------> $1\n\n"
    eval $1
    check_last_call
    let "CURRENT_STEP++"
}

trap return_to_origin_dir INT

ORIGIN_URL=$(git config --get remote.origin.url)
DEPLOYMENT_URL=$(git config --get remote.${TO_UPSTREAM}.url)
if [ -z "$DEPLOYMENT_URL" ]
then
    echo "There is not an URL defined for ${TO_UPSTREAM}"
    exit 1
fi

CALL_DIR=$(pwd)
echo "Called from: $(pwd)"
cd $DIR
echo "Script Location: $(pwd)"
TEMP_DIR=$(mktemp -d)
check_last_call


run_step "cd ${TEMP_DIR}"
run_step "git clone ${DEPLOYMENT_URL}"
run_step "cd GLaDOS-deployment"
run_step "git remote add deploy_from ${ORIGIN_URL}"
run_step "git checkout master"
run_step "git pull"
run_step "git pull --commit --no-edit deploy_from master"
run_step "git push"
run_step "git tag -a DEPLOY_${TAG_NAME} -m 'Deployment using script on ${TAG_NAME}'"
run_step "git push origin DEPLOY_${TAG_NAME}"
return_to_origin_dir
