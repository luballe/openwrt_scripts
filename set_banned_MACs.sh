#!/bin/bash
# Functions and parameters

DEFAULT=default                             # Default param value.
pids=""

set_config_wifi () {
  if [ -z "$1" ]
  then
    echo "-Parameter #1 is zero length.-"
    return
  fi

  variable=${1-$DEFAULT}

  if [ ! "$2" ]
  then
    echo " No second parameter"
    return
  fi

  if [ ! "$3" ]
  then
    echo " No third parameter"
    return
  fi
  #echo "conf,"$1","$2","$3

  # Delete, if exists, the temp file
  if [ -f /tmp/$3 ]; then
    rm /tmp/$3
  fi
  file=tmpl_$3.txt
  #echo $file
  cmd="cat $file > /tmp/$3"
  #echo $cmd
  eval $cmd
  # Iterate over the banned MACs
  file2=banned_MACs.txt
  while read -r addr
  do
    # Concat the new line with the address to ban
    echo -e "\tlist maclist '"$addr"'" >> /tmp/$3
  done < $file2

  #Copy config file to router
  cmd="scp /tmp/$3 $1@$2:/etc/config/wireless"
  #echo $cmd
  eval $cmd

  #Set wifi down
  echo "Restarting WiFi "$3"..."
  cmd="ssh $1@$2 wifi down"
  #echo $cmd
  eval $cmd
  
  #Wait 2 secs
  sleep 2

  #Set Wifi up
  cmd="ssh $1@$2 wifi up"
  #echo $cmd
  eval $cmd
  echo $3" done!"
  return 0
}

function main
{
  #Iterate for every line and spawn process
  file1=routers.txt
  while read -r line
  do
    #echo $line
    # Get user and ip
    user=$(echo "$line"|cut -f 1 -s -d ",")
    ip=$(echo "$line"|cut -f 2 -s -d ",")
    name=$(echo "$line"|cut -f 3 -s -d ",")
    #echo "main,"$user","$ip","$name
    #Spawn a process for each router
    set_config_wifi $user $ip $name &
    #Add a pid to the list of pids
    pids="$pids $!"
 
  done < $file1

  # Wait for every spawned process to finish
  wait $pids
}

main

exit 0
    

