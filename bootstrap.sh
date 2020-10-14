#!/bin/bash

# This file lives on an editable partition alongside:
# - ansible-repo which is a mirror of RPMs needed for Ansible
# - vault the vault with secrets in it

script_dir=$(dirname "$0")

install_ansible() {
  echo <<END > /etc/yum.repos.d/ansible.repo
[ansible-bootstrap]
name=ansible-boostrap
baseurl=file:///tmp/ansible-bootstrap-repo
enabled=1
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=True
END
  dnf install -y ansible
}

# install ansible if necessary
rpm -q ansible || install_ansible

# copy vault file to a predictable location
test -f /etc/ansible/vault || cp $script_dir/vault /etc/ansible/vault

ansible-playbook -e @/etc/ansible/vault --ask-vault-pass--ask-vault-pass $script_dir/setup_workstation.yml
