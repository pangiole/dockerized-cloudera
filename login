#!/usr/bin/env bash

container="${1}"
if [[ "${container}x" == "x" ]]; then
  echo "Usage: ./login <container>"
  exit -1
fi

case ${container} in
  edge)
    user=alice
    ;;
  namenode|datanode)
    user=hdfs
    ;;
  resourcemanager|nodemanager)
    user=yarn
    ;;
  jobhistory)
    user=mapred
    ;;
  hive)
    user=hive
    ;;
esac


docker container exec -it ${container} bash -c "su - ${user}"
