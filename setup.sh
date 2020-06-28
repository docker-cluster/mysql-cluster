slave_user="slave"
slave_password="slavepass"
root_password="123456"
master_container="mysql-master"
docker network create mysql-cluster
docker-compose -f master/master.yml up -d
until docker exec mysql-master sh -c 'mysql -uroot -p '$root_password' -e ";"'
  do
      echo "mysql-master loading...."
      sleep 5
  done
create_user='GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO "'$mysql_user'"@"%" IDENTIFIED BY "'$mysql_password'"; FLUSH PRIVILEGES;'
docker exec -it $master_container sh -c 'mysql -uroot -p '$root_password' -e '$create_user''
docker exec -it $master_container sh -c 'mysql -uroot -p '$root_password' -e "show master status;"'