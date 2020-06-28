#!/bin/bash

slave_user="slave"
slave_password="123456"
root_password="123456"
master_container="mysql-master"
docker network create mysql-cluster
docker-compose -f master/master.yml up -d
until docker exec -it $master_container mysql -uroot -p$root_password -e ";"
  do
      echo "mysql-master loading....(will retry several times)"
      sleep 5
  done
create_user='GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO "'$slave_user'"@"%" IDENTIFIED BY "'$slave_password'"; FLUSH PRIVILEGES;'
docker exec -it $master_container mysql -uroot -p$root_password -e "'$create_user'"
docker exec -it $master_container mysql -uroot -p$root_password -e "show master status;"

exit 0