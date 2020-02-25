# Ansible Systems Engineer Administrative Access

* For providing SysEng access for administrative control of servers
* Creates user accounts on the system
* Adds sudoers template to grant access
* Supports RHEL 6 / 7

## Example Usage

    ---
    - hosts: all
      name: Server Setup
      become: yes
      
      vars:
        devops_access_users:
          - { username: www-data, pubkey: ~/.ssh/id_rsa.pub }
          - { username: my_user_name, pubkey: files/ssh-keys/my_user_name }
          - { username: other_admin, pubkey: files/ssh-keys/other_admin }
    
      roles:
        - { role: classyllama.syseng-access }
