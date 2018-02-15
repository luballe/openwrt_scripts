#!/bin/bash

is_alive_ping()
{
  ping -c 1 $1 > /dev/null
  if [ $? -eq 0 ] 
  then 
    echo Node with IP: $i is up.
#  else
#    echo Node with IP: $i is down.
  fi

}

for i in 192.168.1.{1..254} 
do
  is_alive_ping $i & disown
done
