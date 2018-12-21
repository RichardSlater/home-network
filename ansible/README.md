# Ansible

Configures the Raspberry Pi for Pi-hole and other services.

Pre-requisites:

 - Raspberry Pi booted.
 - Static IP assigned in UniFi Controller.
 - `ansible` user created.
 - Valid SSH key deployed to `authorized_keys` file for `ansible`.

Commands to execute:

     $ cd plays
     $ ansible-playbook --user ansible --inventory '10.229.1.5,' lockdown.yml --vault-password-file ~/ansible_password