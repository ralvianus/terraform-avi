#!/bin/bash

## env variables
AVIUSER="admin"
PASS="VMware1!SDDC"
ENDPOINT="avic.lab01.one"
DNSSERVER="172.16.10.2"
DOMAIN="lab01.one"

## login
LOGINHEADERS=$(curl -kvs -X POST \
	--data-urlencode "username=$AVIUSER" \
	--data-urlencode "password=$PASS" \
"https://$ENDPOINT/login" 2>&1 | grep -i set-cookie)

## get cookies
CSRFREGEX='csrftoken=([A-Za-z0-9]+)'
if [[ $LOGINHEADERS =~ $CSRFREGEX ]]; then
	CSRFTOKEN=${BASH_REMATCH[1]}
fi
printf "%s\n" "X-CSRFToken	[[ $CSRFTOKEN ]]"
SESSIONREGEX='avi-sessionid\=([A-Za-z0-9]+)'
if [[ $LOGINHEADERS =~ $SESSIONREGEX ]]; then
	SESSIONID=${BASH_REMATCH[1]}
fi
printf "%s\n" "avi-sessionid	[[ $SESSIONID ]]"

## update password
if [[ -n "$CSRFTOKEN" && -n "$SESSIONID" ]]; then
	read -r -d '' BODY <<-CONFIG
  "dns_configuration": {
    "server_list": [
      {
        "addr": "$DNSSERVER",
        "type": "V4"
      }
    ],
    "search_domain": "$DOMAIN"
  }
	CONFIG
	curl -ks -X PUT \
		-b "sessionid=$SESSIONID;csrftoken=$CSRFTOKEN" \
		-H "Referer: https://$ENDPOINT" \
		-H "X-Avi-Version: 20.1.6" \
		-H "X-CSRFToken: $CSRFTOKEN" \
		-H "Content-Type: application/json" \
		--data "$BODY" \
	"https://$ENDPOINT/api/systemconfiguration"
	echo "DNS Server [ $DNSSERVER ] configured"
else
	echo "CSRFTOKEN or SESSIONID missing - check credentials"
fi
