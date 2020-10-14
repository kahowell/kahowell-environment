#!/bin/bash
set -e
FEDORA_VERSION=32
FEDORA_RELEASE=1.6

target_drive=$1
if [ -z $target_drive ]; then
  drive_candidates=$(find /dev/disk/by-id -type l | grep usb | grep -v part)
  if [ $(echo $drive_candidates | wc -l) -eq 1 ]; then
    drive_candidate=foo
  fi
  echo "Drive not specified! Likely candidates:"
  for drive in $drive_candidates; do
    echo "  $drive ($(readlink -f $drive))"
  done
  echo "Please re-run with the device specified; for example: $0 $drive"
  exit 1
else
  echo "Installing to $target_drive"
fi

iso_url=https://download.fedoraproject.org/pub/fedora/linux/releases/$FEDORA_VERSION/Server/x86_64/iso/Fedora-Server-dvd-x86_64-$FEDORA_VERSION-$FEDORA_RELEASE.iso
iso_filename=$(basename $iso_url)
test -f $iso_filename || test -f $iso_filename.unverified || wget $iso_url -O $iso_filename.unverified

checksum_url=https://getfedora.org/static/checksums/Fedora-Server-$FEDORA_VERSION-$FEDORA_RELEASE-x86_64-CHECKSUM
checksum_filename=$(basename $checksum_url)
test -f $checksum_filename || wget $checksum_url

if [ ! -f $iso_filename ]; then
  echo "Checking $iso_filename via sha256sum"
  cat $checksum_filename | grep $iso_filename | sed "s#$iso_filename#$iso_filename.unverified#" | sha256sum -c
  mv $iso_filename.unverified $iso_filename
fi

echo "Copying installation ISO to $target_drive. This will take some time..."
sudo livecd-iso-to-disk --format --efi --force --label f${FEDORA_VERSION}_install --nobootmsg --nomenu --ks fedora$FEDORA_VERSION.ks $iso_filename $target_drive

# collect RPMs to install Ansible
if [ ! -d ansible-repo ]; then
  temproot=$(mktemp -d)
  mkdir -p ansible-repo
  pushd ansible-repo
  dnf download -y --releasever=$FEDORA_VERSION --resolve --installroot=$temproot ansible
  popd
  rm -rf $temproot
  createrepo ansible-repo
fi

./update_flash_drive.sh $target_drive
