sudo nmap -sP 192.168.1.0/24 | awk '/MAC Address:/{print ","$3;}/Nmap scan report for/{printf $5;}' | cut -f 1,2 -s -d"," | awk -F, '{print $2,$1}' OFS=,
