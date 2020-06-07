# Ansible Collection - kahowell.home

Automation used to maintain my Fedora-based workstation setup. Use at your own risk.

Primarily for home use.

`setup_workstation.yml` sets up everything, requires root
`setup_user.yml` does only user-specific tasks (is included in `setup_workstation.yml`), but does not require root

To use, create a vault file with some items in it (see `vault.example`), assuming its path is `./vault`, then:

```
sudo ansible-playbook -e @vault --ask-vault-pass setup_workstation.yml
```
