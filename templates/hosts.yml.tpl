# Ansible configuration
#
# Variables in app:vars variables are shared between environments
# and can be overloaded by defining them in the environment.
#
#

app:
  vars:
    db_name: {{DB_DEV_DATABASE_NAME}}
    db_user: {{DB_DEV_USER}}
    db_pwd:  {{DB_DEV_PASS}}

  hosts:
    dev:
      ansible_host: localhost

    staging:
      ansible_host: 37.187.57.175
      db_pwd:       #database-password
      db_name:      #database-name
      #db_user:     #database-user
      host_url:     #https://project-staging.fabernovel.co
      project_root: #/home/webdev/skeleton-test/project-skeleton-ansible/

    # Uncomment to enable
    # preprod:
    #   ansible_host:
    #   db_pwd:       #database-password
    #   db_name:      #database-name
    #   db_user:      #database-user
    #   host_url:
    #   project_root:

    # prod:
    #   ansible_host:
    #   db_pwd:
    #   db_name:
    #   host_url:
    #   project_root:
