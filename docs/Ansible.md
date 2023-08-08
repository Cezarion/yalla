Ansible nécessite l'échange de clés ssh pour bien fonctionner, sinon( mode: ask_pass=true) : 
```
fatal: [staging]: FAILED! => {
    "failed": true,
    "msg": "to use the 'ssh' connection type with passwords, you must install the sshpass program"
}
```

et ssh pass est une faille de sécurité

Playbook de test : 
```

- name: Test privilege escalation
  vars_files:
    - ./group_vars/vault.yml
  hosts: app
  gather_facts: true
  become: true
  roles:
    - tests
```
