#!/bin/bash
if [[ -z "$MULTI_DOMAIN" || -z "$DOMAIN" || -z "$RESOURCE_GROUP" || -z "$GATEWAY_NAME" || -z "$GATEWAY_CERT_NAME" || -z "$EMAIL" || -z "$STORAGE_ACCOUNT_NAME" || -z "$USERNAME" || -z "$PASSWORD" || -z "$TENANT" ]]; then
    echo "Missing environment variables" 1>&2
    exit 1
fi

# EXPIRATION_DAY_LEFT is set to 30 if not defined,
# if this number is larger than number of deys left before cert expire, this process will exit.
if [[ -z "$EXPIRATION_DAY_LEFT" ]]; then
    expiration_day_left=30
else
	expiration_day_left=$EXPIRATION_DAY_LEFT
fi

website="$DOMAIN"
date=$(echo | openssl s_client -servername ${website} -connect ${website}:443 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | sed "s/.*=\(.*\)/\1/")
date_s=$(date -d "${date}" +%s)
now_s=$(date -d now +%s)
date_diff=$(( (date_s - now_s) / 86400 ))
date_diff=$(($date_diff + 0))

if [ $date_diff -gt $expiration_day_left ]; then
	echo "Expiration date is still longer than ${expiration_day_left} day(s)!" 1>&2
	exit 1
fi

if [[ ${MULTI_DOMAIN} == 'yes' ]]; then
  certbot certonly --manual --manual-auth-hook ${PWD}/auth.sh -d ${DOMAIN} -d www.${DOMAIN} --agree-tos --manual-public-ip-logging-ok --email ${EMAIL}
else
  certbot certonly --manual --manual-auth-hook ${PWD}/auth.sh -d ${DOMAIN} --agree-tos --manual-public-ip-logging-ok --email ${EMAIL}
fi

PASSWORD=$(pwgen 29)

# Create PFX file
openssl pkcs12 -export -out certificate.pfx -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -in /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -password pass:${PASSWORD}

# Update Application Gateway with new SSLCertificate
az network application-gateway ssl-cert update -g ${RESOURCE_GROUP} --gateway-name ${GATEWAY_NAME} -n ${GATEWAY_CERT_NAME} \
    --cert-file certificate.pfx --cert-password ${PASSWORD}
