#!/bin/bash
IPADDR=$(wget -q -O- http://whatismyip.akamai.com --no-check-certificate)
RESULT=$(wget -q -O- "https://directnic.com/dns/gateway/ **<YOUR ID STRING HERE>** /?data=$IPADDR")

