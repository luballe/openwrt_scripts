awk -v ORS="," '/lease/||/hardware ethernet/||/client-hostname/{gsub(/{|\;|\"/,"");print "\""$NF"\"" }' /var/lib/dhcp/dhcpd.leases|sed -r 's/(^.*),/\1/'
