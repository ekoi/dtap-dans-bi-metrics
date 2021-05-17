#!/usr/bin/env bash

set -e

BASE_BOX=$1
VAGRANT_REPO_URL=http://nexus.dans.knaw.nl/repository/vagrant/
LOG_FILE=./box-upload.log

curl --progress-bar -u $NEXUS_USER:$NEXUS_PASSWORD --upload-file $BASE_BOX $VAGRANT_REPO_URL | tee -a "${LOG_FILE}" ; test ${PIPESTATUS[0]} -eq 0
