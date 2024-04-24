# устанавливаем основные инструменты (на всех узлах кластера)
sudo apt update
sudo apt install default-jdk mc -y

wget https://dlcdn.apache.org/cassandra/4.1.4/apache-cassandra-4.1.4-bin.tar.gz
tar -xzvf apache-cassandra-4.1.4-bin.tar.gz
mv apache-cassandra-4.1.4 /opt/cassandra

# проставляем имена хостов (на всех узлах кластера)
tee /etc/hosts <<EOF
127.0.0.1 localhost

::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

192.168.1.72    cassandra1
192.168.1.56    cassandra2
192.168.1.41    cassandra3
EOF

#1
tee /opt/cassandra/conf/cassandra.yaml <<EOF
cluster_name: 'XD8CassandraCluster'
num_tokens: 256
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
         - seeds: "192.168.1.72"
listen_address: 192.168.1.72
rpc_address: 192.168.1.72
endpoint_snitch: GossipingPropertyFileSnitch
data_file_directories:
  - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog
commitlog_sync: periodic
commitlog_sync_period: 10000ms
partitioner: org.apache.cassandra.dht.Murmur3Partitioner
saved_caches_directory: /var/lib/cassandra/saved_caches
EOF

#2
tee /opt/cassandra/conf/cassandra.yaml <<EOF
cluster_name: 'XD8CassandraCluster'
num_tokens: 256
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
         - seeds: "192.168.1.72"
listen_address: 192.168.1.56
rpc_address: 192.168.1.56
endpoint_snitch: GossipingPropertyFileSnitch
data_file_directories:
  - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog
commitlog_sync: periodic
commitlog_sync_period: 10000ms
partitioner: org.apache.cassandra.dht.Murmur3Partitioner
saved_caches_directory: /var/lib/cassandra/saved_caches
EOF

#3
tee /opt/cassandra/conf/cassandra.yaml <<EOF
cluster_name: 'XD8CassandraCluster'
num_tokens: 256
seed_provider:
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
         - seeds: "192.168.1.72"
listen_address: 192.168.1.41
rpc_address: 192.168.1.41
endpoint_snitch: GossipingPropertyFileSnitch
data_file_directories:
  - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog
commitlog_sync: periodic
commitlog_sync_period: 10000ms
partitioner: org.apache.cassandra.dht.Murmur3Partitioner
saved_caches_directory: /var/lib/cassandra/saved_caches
EOF

mkdir /var/lib/cassandra
mkdir /var/lib/cassandra/data
mkdir /var/lib/cassandra/commitlog
mkdir /var/lib/cassandra/saved_caches

tee -a ~/.bashrc <<EOF

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export CASSANDRA_HOME=/opt/cassandra
export PATH=\$PATH:\${CASSANDRA_HOME}/bin
EOF

source ~/.bashrc

# cassandra -fR

tee /etc/systemd/system/cassandra.service <<EOF
[Unit]
Description=Apache Cassandra Database
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/cassandra/bin/cassandra -fR
ExecStop=/opt/cassandra/bin/nodetool stop
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable cassandra
systemctl start cassandra