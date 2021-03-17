#!/bin/bash

if [[ ${MULTI_DOMAIN} == 'yes' ]]; then
  certbot certonly --manual --manual-auth-hook ${PWD}/auth.sh -d ${DOMAIN} -d www.${DOMAIN} --agree-tos --manual-public-ip-logging-ok --email '${EMAIL}'
else
  certbot certonly --manual --manual-auth-hook ${PWD}/auth.sh -d ${DOMAIN} --agree-tos --manual-public-ip-logging-ok --email '${EMAIL}'
fi

PASSWORD=$(pwgen 29)

# Create PFX file
openssl pkcs12 -export -out certificate.pfx -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -password pass:${PASSWORD}

# Update Application Gateway with new SSLCertificate
az network application-gateway ssl-cert update -g ${RESOURCE_GROUP} --gateway-name ${GATEWAY_NAME} -n ${GATEWAY_CERT_NAME} \
    --cert-file certificate.pfx --cert-password ${PASSWORD}
