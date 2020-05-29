#!/bin/bash
printf "Welcome to the AODNS script, it will fetch the more secured and reliable free DNS from the Opennic project install them.\n Don't hesitate to run this script again if you have network issues, those DNSs can sometimes be capricious"
curl -s https://servers.opennic.org | grep "No logs kept" | grep "Pass" | sed 's/<[^>]*>//g' | cut -c 5-190 | cut -d';' -f1
