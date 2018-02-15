
awk 'BEGIN{
    RS="}"
    FS="\n"
}
/lease/{
    for(i=1;i<=NF;i++){
        gsub(";","",$i)
        if ($i ~ /lease/) {
            m=split($i, IP," ")
            ip=IP[2]
        }
        if( $i ~ /hardware/ ){
            m=split($i, hw," ")
            ether=toupper(hw[3])
        }
        if ( $i ~ /client-hostname/){
            m=split($i,ch, " ")
            hostname=ch[2]
        }
        if ( $i ~ /uid/){
            m=split($i,ui, " ")
            uid=ui[2]
        }
    }
    if (ip=="")
      ip="NULL"
    if (hostname=="")
      hostname="\"NULL\""
    if (ether=="")
      ether="NULL"
    if (uid =="")
      uid="NULL"

    hostname2=substr(hostname,2,length(hostname)-2)

    print ether "," hostname2
} ' /var/lib/dhcp/dhcpd.leases | awk '!NF || !seen[$0]++'

