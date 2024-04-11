sudo apt update
sudo apt install zookeeperd mc

# --

tee -a /etc/hosts <<EOF
192.168.1.54    zookeeper1
192.168.1.45    zookeeper2
192.168.1.68    zookeeper3
EOF

tee -a /etc/zookeeper/conf/zoo.cfg <<EOF
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
EOF

systemctl enable zookeeper
systemctl start zookeeper
systemctl status zookeeper
