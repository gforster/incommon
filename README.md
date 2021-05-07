# certificates

A repo to create, request, manage, and track ssl certificates

## Initial Setup
- A "driver" file in the root of this repository to hold the vault password (see Vault) for encrypting the keys is required for `private-key.yml`

  ```bash
  ansible-vault encrypt {{ temp_dir }}/{{ common_name }}.vault --vault-password-file=driver
  ```

## Procedure
- A new directory is created when private-key.yml is ran in `vars` corresponding to the "common_name" or "fqdn" of the server cert to be created

- If you need to override the defaults (read `defaults/main.yml`), you may also do in `vars/{{ common_name }}/vars.yml`

- Run the following, changing the COMMON_NAME and SAN_LIST to match the appropriate values
```
# the domain name of the certificate to create
export COMMON_NAME=example.domain.edu
# a comma-separated list of subject alternative names for the certificate
export SAN_LIST=example.domain.edu
# Create a privatekey and common_name directory
ansible-playbook private-key.yml --vault-password-file=driver -e common_name=${COMMON_NAME} -e sans_list_string=${SAN_LIST}
# Create the CSR
ansible-playbook csr.yml --vault-password-file=driver -e common_name=${COMMON_NAME}
# Enroll the cert in InCommon
ansible-playbook enroll.yml --vault-password-file=driver -e common_name=${COMMON_NAME}
# Collect the cert 
ansible-playbook collect.yml --vault-password-file=driver -e common_name=${COMMON_NAME}

# Output the cert and key to the localhost /tmp directory
export COMMON_NAME=example.domain.edu
ansible-playbook local-files.yml -e common_name=${COMMON_NAME} -e certmgr_dest_dir='/tmp' --vault-password-file=driver
```

# InCommon SSL API Integration

* InCommon provides an API for which we have designed some ansible tasks to enroll and download certificates that are managed from this repository
* in the vars/ sub directory, we have multiple directories indexed by the main (or inventory) hostname that holds both the encrypted and unencrypted variables for interaction and certificate management
* #FIXME - add diagram of logic
* 


# enroll certificate info
* https://enterprise.comodo.com/resources/pdf/InCommon_CM_SSL_Web_Service_API.pdf
* link to servertype integer in server enrollment
* See also: https://cert-manager.com/customer/InCommon/ssl for manual process
