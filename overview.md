# Список машин и их назначение

    * Proxy (на него будут прокинуты порты снаружи, 
        также будет использоваться для балансировки k8s мастеров)
        proxy
    
    * Kubernetes
        k8s1 - master
        k8s2 - master
        k8s3 - master
        k8s4 - worker
        k8s5 - worker
        k8s6 - worker

    * Базы данных
        postgres1
        postgres2
        postgres3
        clickhouse1
        clickhouse2
        clickhouse3

    * Hadoop
        hadoop1 - namenode
        hadoop2 - secondary namenode, datanode
        hadoop3 - datanode
        hadoop4 - datanode

    * Kafka
        kafka1
        kafka2
        kafka3
        
    * CI-CD и Остальное
        gitlab
        gitlab-worker - здесь в докере будут запускаться образы сборщиков (runner)
        nexus
        redmine
        docker-host - для слабонагруженых сервисов и админок


Итого машин: 24

---

Скрипт создания:
```
lxc launch ubuntu:20.04 proxy --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 k8s1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 k8s2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 k8s3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 k8s4 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 k8s5 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 k8s6 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 postgres1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 postgres2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 postgres3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 clickhouse1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 clickhouse2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 clickhouse3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 zookeeper1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 zookeeper2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 zookeeper3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 hadoop1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 hadoop2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 hadoop3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 hadoop4 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 hadoop5 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 gitlab --vm --network enp5s0 --config limits.cpu=1 --config limits.memory=4096MB
lxc launch ubuntu:20.04 gitlab-worker --vm --network enp5s0 --config limits.cpu=1 --config limits.memory=4096MB
lxc launch ubuntu:20.04 nexus --vm --network enp5s0 --config limits.cpu=1 --config limits.memory=4096MB
lxc launch ubuntu:20.04 redmine --vm --network enp5s0 --config limits.cpu=1 --config limits.memory=4096MB

lxc launch ubuntu:20.04 kafka1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 kafka2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 kafka3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 cassandra1 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 cassandra2 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
lxc launch ubuntu:20.04 cassandra3 --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB

lxc launch ubuntu:20.04 docker-host --vm --network enp5s0 --config limits.cpu=4 --config limits.memory=4096MB
```

Проставить ssh key:
```
lxc shell k8s1

tee ~/.ssh/authorized_keys <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXIYlhbOCiB46Twrmzh3D5N/o8QnDmwEWlaHfoLo2Ot evgeny@evgeny-z97
EOF
```

Скрипт остановки:
```
lxc stop proxy --force

lxc stop k8s1 --force
lxc stop k8s2 --force
lxc stop k8s3 --force
lxc stop k8s4 --force
lxc stop k8s5 --force
lxc stop k8s6 --force

lxc stop postgres1 postgres2 postgres3 --force

lxc stop clickhouse1 --force
lxc stop clickhouse2 --force
lxc stop clickhouse3 --force

lxc stop zookeeper1 zookeeper2 zookeeper3 --force

lxc stop kafka1 --force
lxc stop kafka2 --force
lxc stop kafka3 --force

lxc stop hadoop1 hadoop2 hadoop3 hadoop4 hadoop5 --force

lxc stop gitlab --force
lxc stop gitlab-worker --force
lxc stop nexus --force
lxc stop redmine --force
lxc stop docker-host --force
```

Скрипт запуска:
```
lxc start proxy

lxc start k8s1 k8s2 k8s3 k8s4 k8s5 k8s6
lxc start postgres1 postgres2 postgres3
lxc start clickhouse1 clickhouse2 clickhouse3
lxc start kafka1 kafka2 kafka3
lxc start hadoop1 hadoop2 hadoop3 hadoop4 hadoop5

lxc start gitlab
lxc start gitlab-worker
lxc start nexus
lxc start redmine
lxc start docker-host
```

Скрипт удаления:
```
lxc delete proxy --force

lxc delete k8s1 --force
lxc delete k8s2 --force
lxc delete k8s3 --force
lxc delete k8s4 --force
lxc delete k8s5 --force
lxc delete k8s6 --force

lxc delete postgres1 --force
lxc delete postgres2 --force
lxc delete postgres3 --force

lxc delete clickhouse1 --force
lxc delete clickhouse2 --force
lxc delete clickhouse3 --force

lxc delete hadoop1 --force
lxc delete hadoop2 --force
lxc delete hadoop3 --force
lxc delete hadoop4 --force

lxc delete gitlab --force
lxc delete gitlab-worker --force
lxc delete nexus --force
lxc delete redmine --force
lxc delete docker-host --force
```