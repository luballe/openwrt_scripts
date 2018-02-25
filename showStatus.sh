pids=""
if [ -f /tmp/macsFromRouter.txt ]; then
  rm /tmp/macsFromRouter.txt
fi
if [ -f /tmp/ipsFromNmap.txt ]; then
  rm /tmp/ipsFromNmap.txt
fi
if [ -f /tmp/hostnamesFromLeases.txt ]; then
  rm /tmp/hostnamesFromLeases.txt
fi
if [ -f /tmp/temp1.txt ]; then
  rm /tmp/temp1.txt
fi
if [ -f /tmp/temp2.txt ]; then
  rm /tmp/temp2.txt
fi
#echo "getting MAC addresses from routers... "
/home/pi/openwrt_scripts/getMACsFromRouter.sh > /tmp/macsFromRouter.txt &
pids="$pids $!"
#echo "Done!"
#echo "getting all active hosts from nmap... "
/home/pi/openwrt_scripts/getIPsFromNmap.sh > /tmp/ipsFromNmap.txt &
pids="$pids $!"
#echo "Done!"
#echo "getting hostnames by mac address from leases... "
/home/pi/openwrt_scripts/getHostNamesFromLeases.sh > /tmp/hostnamesFromLeases.txt &
pids="$pids $!"
#echo "Done!"

# Wait for every spawned process to finish
wait $pids

awk '
    BEGIN {FS=OFS=","}
    FNR==NR {f2[$1]=$2;next}
    {if ($2 in f2)
      print $0,f2[$2]
    else
      print $0,"NotFound"}
' /tmp/ipsFromNmap.txt /tmp/macsFromRouter.txt > /tmp/temp1.txt

awk '
    BEGIN {FS=OFS=","}
    FNR==NR {f2[$1]=$2;next}
    {if ($2 in f2)
      print $0,f2[$2]
    else
      print $0,"NotFound"}
' /tmp/hostnamesFromLeases.txt /tmp/temp1.txt > /tmp/temp2.txt

#date_cmd=`date '+%Y-%m-%d %H:%M:%S'` 
date_cmd=`date '+%Y-%m-%d %H:%M'` 
#echo "$date_cmd"

awk -v a="$date_cmd" '
    BEGIN {FS=OFS=","}
    FNR==NR {f2[$1]=$2;next}
    {if ($2 in f2)
      print a,$0,f2[$2]
    else
      print a,$0,"NotFound"}
' /home/pi/openwrt_scripts/hotelDevices.txt /tmp/temp2.txt

