#!/usr/bin/env bash

if (( $# < 1 )); then
  echo "Usage: ./repackage.sh <host>"
  exit 1
fi

VM_TO_REPACKAGE=$1
VMLISTFILE=$TMPDIR/vms
BOX_FILE=${TMPDIR%/}/$VM_TO_REPACKAGE-$(date  +"%Y-%m-%d").box

echo -n "Removing old box file $BOX_FILE if it exists..."
rm $BOX_FILE > /dev/null
echo "OK"

echo -n "Getting name of VM..."
VBoxManage list vms | grep dataversenl-dtap_$VM_TO_REPACKAGE | sed -E 's/^"(.*)".*$/\1/' > $VMLISTFILE
echo "OK"

MATCHING_VMS=$(cat $VMLISTFILE)
echo "Matching VM:"
echo "$MATCHING_VMS"

NUMBER_OF_VMS=$(cat $VMLISTFILE | wc -l)

echo $NUMBER_OF_VMS

if (( $NUMBER_OF_VMS > 1 )); then
    echo "More than one instance found for $VM_TO_REPACKAGE, please make sure there is only one. FAILED."
    exit 1
fi

echo -n "Executing prepare-for-repackage.sh script on current VM..."
vagrant ssh $VM_TO_REPACKAGE -c 'bash -s' < resource/prepare-for-repackage.sh
echo "OK"
echo -n "Repackaging VM $MATCHING_VMS..."
vagrant package --base $(echo $MATCHING_VMS) --output $BOX_FILE
echo "OK"
echo "Vagrant box created at: $BOX_FILE"
