#!/bin/bash

set -x

for host in $(cat "hosts"); do
    (
      echo "copy RUM to $host"
      scp RemoteUpdateManager Administrator@$host:/tmp
     
      echo "install with RUM in $host"
      ssh Administrator@$host "sudo -S /tmp/RemoteUpdateManager <<< 'password'"
    ) &
done

wait
