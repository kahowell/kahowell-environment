kahowell-environment
====================

Ansible role to manage my laptop setup. Feel free to reference or re-use (at your own risk).

You can use this lazilly by installing in e.g. `~/.ansible/roles/kahowell-environment` and then running:

```
ansible-playbook -K ~/.ansible/roles/kahowell-environment/provision.yml
```

Requirements
------------

Brew installation on linux is a little tricky to do with Ansible. You may have to manually install brew before running the role.

Role Variables
--------------

N/A

Dependencies
------------

N/A

Example Playbook
----------------

```
    - hosts: localhost
      roles:
         - { role: kahowell-environment }
```

License
-------

MIT

Author Information
------------------

https://kahowell.net
