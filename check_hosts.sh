#!/bin/bash

for i in $@
do
  ping -c 1 $i &> /dev/null
  if [ $? -ne 0 ]; then
    echo "`date`: ping failed, $i host is down!" 
    echo "`date`: ping failed, $i host is down!" | mail -s "$i host is down!" gerencia@ermita-hotel.com
  fi
done
