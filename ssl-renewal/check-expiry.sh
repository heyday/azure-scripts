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
	exit 0
fi
