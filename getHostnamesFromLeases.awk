#!/usr/bin/awk -f

BEGIN{
    RS="}"
    FS="\n"
}
/lease/{
ip="NULL"
ether="NULL"
hostname="No hostname"
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
            hostname=substr(hostname,2,length(hostname)-2)
        }
    }
#    print i
    print ether "," hostname "," ip

}
