echo -n "getting MAC addresses by router... "
./showMACsbyRouter.sh > /tmp/macsByRouter.txt
echo "Done!"
echo -n "getting all active hosts... "
./showAllActiveHostsFromNmap.sh > /tmp/allActiveHostsFromNmap.txt
echo "Done!"
echo -n "getting hostnames by mac address... "
./showHostNamesFromLeases.sh > /tmp/hostnamesFromLeases.txt
echo "Done!"

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

