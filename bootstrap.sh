#!/bin/bash

# This file lives on an editable partition alongside:
# - ansible-repo which is a mirror of RPMs needed for Ansible
# - vault the vault with secrets in it

install_ansible() {
  cat << END > /etc/yum.repos.d/ansible.repo
[ansible-bootstrap]
name=ansible-bootstrap
baseurl=file:///mnt/ansible-repo
enabled=1
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-\$releasever-\$basearch
skip_if_unavailable=True
END
  dnf --disablerepo=* --enablerepo=ansible-bootstrap install -y ansible
}

# install ansible if necessary
rpm -q ansible || install_ansible

# copy vault file to a predictable location
test -f /etc/ansible/vault || cp $(dirname "$0")/vault /etc/ansible/vault

(cd $(dirname "$0"); ansible-playbook -e @/etc/ansible/vault --ask-vault-pass setup_workstation.yml)
