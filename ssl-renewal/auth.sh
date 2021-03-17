#!/bin/bash

echo ${CERTBOT_VALIDATION} > ${CERTBOT_TOKEN}

echo "Creating url ${DOMAIN}/.well-known/acme-challenge/${CERTBOT_TOKEN}"
echo 'file contents is:'
cat ${CERTBOT_TOKEN}

az login --service-principal --username ${USERNAME} --password ${PASSWORD} --tenant ${TENANT}
az storage blob upload --account-name ${STORAGE_ACCOUNT_NAME} --container-name \$web --name .well-known/acme-challenge/${CERTBOT_TOKEN} --file ${CERTBOT_TOKEN}
