#!/bin/bash
set -e
FEDORA_VERSION=32

target_drive=$1
if [ -z $target_drive ]; then
  echo "Please provide the target drive (e.g. /dev/sda)"
  exit 1
fi

bootstrap_partition=$(ls $target_drive*1)
bootstrap_dir=$(mktemp -d)
sudo mount -o rw $bootstrap_partition $bootstrap_dir
sudo rsync -rP /etc/ansible/vault ansible-repo $bootstrap_dir
sudo cp fedora${FEDORA_VERSION}.ks $bootstrap_dir/ks.cfg
sudo rsync -rP --exclude .git --exclude-from='.gitignore' . $bootstrap_dir/ansible-kahowell
#sudo test -d $bootstrap_dir/ansible-kahowell|| sudo git clone https://github.com/kahowell/ansible-kahowell $bootstrap_dir/ansible-kahowell
#sudo bash -c "cd $bootstrap_dir/ansible-kahowell; git pull --ff-only"
sudo umount $bootstrap_dir
rmdir $bootstrap_dir
