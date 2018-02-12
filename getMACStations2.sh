#!/bin/bash
# Functions and parameters

DEFAULT=default                             # Default param value.
pids=""

get_MACs_per_router () {
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

  #cmd="ssh root@$1 /etc/config/show_wifi_clients.sh | awk 'BEGIN {FS=\" \"} {OFS=\",\"} NR>3 {print \"$2\",\$1}'"
  cmd="ssh $1@$2 /etc/config/show_wifi_clients2.sh"
  #echo $cmd
  eval $cmd
  return 0
}

function main
{
  #Iterate for every line and spawn process
  exec < routers.txt
  while read line
  do
    #echo $line
    # Get user and ip
    user=$(echo "$line"|cut -f 1 -s -d " ")
    ip=$(echo "$line"|cut -f 2 -s -d " ")
    #echo $user
    #echo $ip
    # Delete, if exists, the temp files
    if [ -f /tmp/$ip ]; then
      rm /tmp/$ip
    fi
    # Spawn a process for each router
    get_MACs_per_router $user $ip > /tmp/$ip &
    # Add a pid to the list of pids
    pids="$pids $!"
 
  done

  # Wait for every spawned process to finish
  wait $pids

  # Cat the collected info in tmp files  
  exec < routers.txt
  while read line
  do
    #Get ip
    ip=$(echo "$line"|cut -f 2 -s -d " ")
    #Cat file content
    cat /tmp/$ip
  done

}

main

exit 0
    

