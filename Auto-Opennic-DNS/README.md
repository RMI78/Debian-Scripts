# Auto-Opennic-DNS
This script will replace the DNS provided by your ISP by free DNS from the awesome Opennic project. DNS are, most of the time, forgotten when talking about internet privacy. When not using a VPN the applications used generally encrypt your content but doesn't encrypt links where the content is sended, links, that are accessible from your ISP (as they provide you their links through their DNS servers used by default). This is where this script comes up, directly crawling the DNS available from servers.opennic.org and automatically installing it to your network inferface

## How does it works

Just run the script and let it guide you to choose a corresponding DNS server

## requirements

This script require `grep`, `curl` and `sed`
