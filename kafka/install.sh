# https://github.com/naddym/kafka-setup-on-ubuntu

wget https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz
tar -xvf kafka_2.13-3.7.0.tgz
sudo mv kafka_2.13-3.7.0 /opt/kafka

sudo apt update
sudo apt install -y openjdk-8-jdk
swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

mkdir -p /data/kafka
mkdir -p /data/zookeeper

cd /opt/kafka

echo "1" >/data/zookeeper/myid
# echo "2" > /data/zookeeper/myid
# echo "3" > /data/zookeeper/myid

sudo echo "192.168.1.42    kafka1 zookeeper1" >>/etc/hosts
sudo echo "192.168.1.71    kafka2 zookeeper2" >>/etc/hosts
sudo echo "192.168.1.34    kafka3 zookeeper3" >>/etc/hosts

#----
#---- x3
#----

rm config/server.properties
tee /opt/kafka/config/server.properties <<EOF
# change this for each broker
# broker.id=1
# change this to the hostname of each broker
advertised.listeners=PLAINTEXT://kafka1:9092
# The ability to delete topics
delete.topic.enable=true
# Where logs are stored
log.dirs=/data/kafka
# default number of partitions
num.partitions=8
# default replica count based on the number of brokers
default.replication.factor=3
# to protect yourself against broker failure
min.insync.replicas=2
# logs will be deleted after how many hours
log.retention.hours=168
# size of the log files
log.segment.bytes=1073741824
# check to see if any data needs to be deleted
log.retention.check.interval.ms=300000
# location of all zookeeper instances and kafka directory
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
# timeout for connecting with zookeeper
zookeeper.connection.timeout.ms=6000
# automatically create topics
auto.create.topics.enable=true
EOF

rm config/zookeeper.properties
tee config/zookeeper.properties <<EOF
# the directory where the snapshot is stored.
dataDir=/data/zookeeper
# the port at which the clients will connect
clientPort=2181
# setting number of connections to unlimited
maxClientCnxns=0
# keeps a heartbeat of zookeeper in milliseconds
tickTime=2000
# time for initial synchronization
initLimit=10
# how many ticks can pass before timeout
syncLimit=5
# define servers ip and internal ports to zookeeper
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
EOF

tee /etc/systemd/system/kafka.service <<EOF
[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=root
ExecStartPre=/bin/sleep 20
ExecStart=/bin/sh -c '/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /opt/kafka/kafka.log 2>&1'
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

tee /etc/systemd/system/zookeeper.service <<EOF
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=root
ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable zookeeper
sudo systemctl enable kafka

sudo systemctl restart zookeeper
sudo systemctl restart kafka

sudo systemctl status kafka
