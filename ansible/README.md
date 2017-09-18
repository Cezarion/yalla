Ansible Role MySql : https://github.com/geerlingguy/ansible-role-mysql/blob/master/README.md
Ansible Sync MySql : https://gist.github.com/cfxd/481884e980c61ac99150
Ansible Projet Sync MySql : https://github.com/AlphaNodes/ansible-project-sync

# Commande : 
ansible-playbook -i ansible/hosts ansible/roles/debug/tasks/main.yml -e "src=staging dest=dev"