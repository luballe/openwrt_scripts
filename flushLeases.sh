sudo service dhcpcd stop
sudo rm /var/lib/dhcp/dhcpd.leases~
sudo rm /var/lib/dhcp/dhcpd.leases
sudo touch /var/lib/dhcp/dhcpd.leases
sudo service dhcpcd start
