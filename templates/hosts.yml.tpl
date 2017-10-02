# Ansible configuration
#
#     Variables in app:vars variables are shared between environments
#     and can be overloaded by defining them in the environment.
#
# ----------------------------------------------------------------------
#
#  /!\ SECURITY :
#
#     Remote db password are stored in a vault file located in folder
#     PROJECT_ROOT/vaults/vault.yml
#
#     To edit or create a protected file, run
#     yalla av create
#
#     available values :
#     vault_staging_db_pass: your-staging-pass
#     vault_preprod_db_pass: your-preprod-pass
#     vault_live_db_pass:    your-db-pass
#
# ----------------------------------------------------------------------
#
#  VARIABLES OVERLOADABLE BY HOST :
#  see: http://docs.ansible.com/ansible/latest/intro_inventory.html#host-variables
#
#     # env_name:
#         ansible_host:        #server ip / hostname
#         ansible_connection:  local | ssh
#         ansible_user: deploy #no sudo user
#
#         become_user:  devops #sudo user
#         become_method: su | sudo
#
#         #for db password create or edit a vault. See below
#         db_name:      #database-name
#         db_user:      #database-user
#         db_host:      #databse host | default localhost
#
#         host_url:
#         project_root:
#
#         project_root: "{{ inventory_dir }}/../"
#         backup_dir: "{{ project_root }}backup/"
#
#         # Vaults variables
#         db_pwd: "{{ vault_staging_db_pass | default('') }}"
#         ansible_become_pass: "{{ vault_staging_become_pass | default('') }}"
#
# ----------------------------------------------------------------------

app:
  vars:
    db_name: {{DB_DEV_DATABASE_NAME}}
    db_user: {{DB_DEV_USER}}
    db_pwd:  {{DB_DEV_PASS}}
    db_host: localhost

  hosts:
    dev:
      ansible_host: localhost

    staging:
      ansible_host: 37.187.57.175 # fabernovel.co

      #for db password create or edit a vault. See below
      db_name:      #database-name
      #db_user:     #database-user

      host_url:     #https://project-staging.fabernovel.co
      project_root: #/home/webdev/skeleton-test/project-skeleton-ansible/

    # Uncomment to enable
    # preprod:
    #   ansible_host:        #server ip / hostname
    #   ansible_user: deploy #no sudo user
    #.  become_user:  devops #sudo user
    #
    #   #for db password create or edit a vault. See below
    #   db_name:      #database-name
    #   db_user:      #database-user
    #
    #   host_url:
    #   project_root:

    # Uncomment to enable
    # live:
    #   ansible_host:        #server ip / hostname
    #   ansible_user: deploy #no sudo user
    #.  become_user:  devops #sudo user

    #   #for db password create or edit a vault. See below
    #   db_name:
    #   db_user:      #database-user
    #
    #   host_url:
    #   project_root:
