#!/bin/bash

cluster_user="slave"
cluster_password="123456"
root_password="123456"
master_container="mysql-master"
slave_container="mysql-slave"

echo "***************************start to init mysql-cluster containers***************************"
docker-compose down
rm -rf ./master/data/* ./slave/data/*
docker-compose up -d
echo "***************************mysql-cluster containers inited***************************"

echo "***************************start to connect mysql-cluster(will retry several times)***************************"
until docker exec $master_container sh -c 'export MYSQL_PWD='$root_password';mysql -uroot -e ";"'
  do
      echo "mysql-cluster connecting......"
      sleep 4
  done
echo "***************************mysql-cluster connected***************************"

echo "***************************start to init mysql-master***************************"
create_user_stmt='GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO "'$cluster_user'"@"%" IDENTIFIED BY "'$cluster_password'"; FLUSH PRIVILEGES;'
docker exec $master_container sh -c "export MYSQL_PWD='$root_password';mysql -u root -e '$create_user_stmt'"
docker exec $slave_container sh -c 'export MYSQL_PWD='$root_password';mysql -u root -e "show master status;"'
echo "***************************mysql-master inited***************************"

echo "***************************start to init mysql-slave***************************"
master_status=`docker exec $master_container sh -c 'export MYSQL_PWD='$root_password';mysql -u root -e "show master status;"'`
log_name=`echo $master_status | awk '{print $6}'`
log_pos=`echo $master_status | awk '{print $7}'`
#master_ip=`docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $master_container`
set_slave_stmt='change master to master_host="'$master_container'", master_user="'$cluster_user'", master_password="'$cluster_password'", master_port=3306, master_log_file="'$log_name'", master_log_pos='$log_pos';start slave;'
docker exec $slave_container sh -c "export MYSQL_PWD='$root_password';mysql -u root -e '$set_slave_stmt'"
docker exec $slave_container sh -c 'export MYSQL_PWD='$root_password';mysql -u root -e "show slave status \G;"'
echo "***************************mysql-slave inited***************************"
echo "success"

exit 0