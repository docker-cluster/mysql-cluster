# mysql-cluster

## 说明

版本：5.7

端口映射: 33306-33307:3306

规格：一主一从

网络：bridge

目录结构：

``` bash
mysql-cluster/
├── discard.sh
├── docker-compose.yml
├── localtime
├── master
│   └── conf
│       ├── mysql.conf.cnf
│       └── my(\346\263\250\351\207\212).cnf
├── README.md
├── setup.sh
├── slave
│   └── conf
│       ├── mysql.conf.cnf
│       └── my(\346\263\250\351\207\212).cnf
└── timezone
```

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
