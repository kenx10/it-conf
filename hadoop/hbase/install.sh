# https://hbase.apache.org/book.html#hadoop

wget https://dlcdn.apache.org/hbase/2.5.8/hbase-2.5.8-bin.tar.gz
tar -xzvf hbase-2.5.8-bin.tar.gz
mv hbase-2.5.8 /opt/hbase

HBASE_HOME=/opt/hbase
tee -a ~/.bashrc <<EOF
HBASE_HOME=/opt/hbase
export HBASE_HOME
export PATH=$PATH:${HBASE_HOME}/bin
EOF

nano ~/.bashrc

source ~/.bashrc

# ===========================================

tee -a /opt/hbase/conf/hbase-env.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HBASE_PID_DIR=/var/hbase/pids
export HBASE_MANAGES_ZK=true
export HBASE_DISABLE_HADOOP_CLASSPATH_LOOKUP="true"
EOF

# == master only
tee /opt/hbase/conf/hbase-env.xml <<EOF
<configuration>
<property>
    <name>hbase.rootdir</name>
    <value>hdfs://hadoop1:9000/hbase</value>
  </property>
<property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
<property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>hdfs://hadoop1:9000/zookeeper</value>
  </property>
<property>
    <name>hbase.zookeeper.quorum</name>
    <value>hadoop1, hadoop2, hadoop3, hadoop4</value>
  </property>
<property>
    <name>hbase.zookeeper.property.clientPort</name>
    <value>2181</value>
</property>
</configuration>
EOF

tee /opt/hbase/conf/regionservers <<EOF
hadoop1
hadoop2
hadoop3
hadoop4
EOF

tee /etc/systemd/system/hh.service <<EOF
[Unit]
Description=Hadoop && HBase
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/hadoop/sbin/start-dfs.sh && /opt/hadoop/sbin/start-yarn.sh && /opt/hbase/bin/start-hbase.sh
ExecStop=/opt/hbase/bin/stop-yarn.sh && /opt/hbase/bin/stop-dfs.sh && /opt/hadoop/sbin/stop-all.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hh

# == slave only
tee /opt/hbase/conf/hbase-env.xml <<EOF
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://hadoop1:9000/hbase</value>
  </property>

  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
</configuration>
EOF

tee /opt/hbase/conf/regionservers <<EOF
localhost
EOF

# ===========================================
# master

start-all.sh && start-hbase.sh
stop-hbase.sh && stop-all.sh