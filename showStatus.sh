pids=""
if [ -f /tmp/macsByRouter.txt ]; then
  rm /tmp/macsByRouter.txt
fi
if [ -f /tmp/allActiveHostsFromNmap.txt ]; then
  rm /tmp/allActiveHostsFromNmap.txt
fi
if [ -f /tmp/hostnamesFromLeases.txt ]; then
  rm /tmp/hostnamesFromLeases.txt
fi
if [ -f /tmp/temp.txt ]; then
  rm /tmp/temp.txt
fi
echo "getting MAC addresses from routers... "
./showMACsbyRouter.sh > /tmp/macsByRouter.txt &
pids="$pids $!"
#echo "Done!"
echo "getting all active hosts from nmap... "
./showAllActiveHostsFromNmap.sh > /tmp/allActiveHostsFromNmap.txt &
pids="$pids $!"
#echo "Done!"
echo "getting hostnames by mac address from leases... "
./showHostNamesFromLeases.sh > /tmp/hostnamesFromLeases.txt &
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
' /tmp/allActiveHostsFromNmap.txt /tmp/macsByRouter.txt > /tmp/temp.txt

awk '
    BEGIN {FS=OFS=","}
    FNR==NR {f2[$1]=$2;next}
    {if ($2 in f2)
      print $0,f2[$2]
    else
      print $0,"NotFound"}
' /tmp/hostnamesFromLeases.txt /tmp/temp.txt

