# mysql-cluster

## 部署

``` bash
git clone https://github.com/docker-cluster/mysql-cluster.git
cd mysql-cluster
chmod +x setup.sh
./setup.sh
```

## 测试

``` bash
docker exec -it mysql-master mysql -uroot -p123456 -e "create database test;"
docker exec -it mysql-slave mysql -uroot -p123456 -e "show databases;"
```
