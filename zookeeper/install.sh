sudo apt update
sudo apt install mc

# --
tee -a /etc/hosts <<EOF
192.168.1.54    zookeeper1
192.168.1.45    zookeeper2
192.168.1.68    zookeeper3
EOF

# ==============

wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz
tar -xzvf apache-zookeeper-3.8.4-bin.tar.gz
mv apache-zookeeper-3.8.4-bin /opt/zookeeper

sudo mkdir -p /data/zookeeper

tee /data/zookeeper/myid <<EOF
1
EOF

tee /data/zookeeper/myid <<EOF
2
EOF

tee /data/zookeeper/myid <<EOF
3
EOF

tee /opt/zookeeper/conf/zoo.cfg <<EOF
tickTime = 2000
dataDir = /data/zookeeper
clientPort = 2181
initLimit = 5
syncLimit = 2

server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
EOF

cd /opt/zookeeper/

# ==============

tee /etc/systemd/system/zookeeper.service <<EOF
[Unit]
Description=Zookeeper Daemon
Documentation=http://zookeeper.apache.org
Requires=network.target
After=network.target

[Service]
Type=forking
WorkingDirectory=/opt/zookeeper
User=root
Group=root
ExecStart=/opt/zookeeper/bin/zkServer.sh start /opt/zookeeper/conf/zoo.cfg
ExecStop=/opt/zookeeper/bin/zkServer.sh stop /opt/zookeeper/conf/zoo.cfg
ExecReload=/opt/zookeeper/bin/zkServer.sh restart /opt/zookeeper/conf/zoo.cfg
TimeoutSec=30
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# ==============
sudo systemctl daemon-reload
sudo systemctl enable zookeeper
sudo systemctl start zookeeper
