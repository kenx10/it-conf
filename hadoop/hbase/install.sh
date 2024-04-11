# https://hbase.apache.org/book.html#hadoop

wget https://dlcdn.apache.org/hbase/2.5.8/hbase-2.5.8-bin.tar.gz
tar -xzvf hbase-2.5.8-bin.tar.gz
mv hbase-2.5.8 /opt/hbase

HBASE_HOME=/opt/hbase

tee -a ~/.bashrc <<EOF
HBASE_HOME=/opt/hbase
export HBASE_HOME
export PATH=\$PATH:\${HBASE_HOME}/bin
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
    <value>hadoop1, hadoop2, hadoop3, hadoop4, hadoop5</value>
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
hadoop5
EOF

tee /opt/start-hh.sh <<EOF
#!/bin/sh

for hostname in "\$@"
do
    while ! ping -c 1 \$hostname &>/dev/null
            do echo "\$hostname: Ping Fail"
    done
    echo "\$hostname: Ping OK"
done

/opt/hadoop/sbin/start-dfs.sh && /opt/hadoop/sbin/start-yarn.sh && /opt/hbase/bin/start-hbase.sh
EOF

tee /opt/stop-hh.sh <<EOF
/opt/hbase/bin/stop-hbase.sh && /opt/hadoop/sbin/stop-dfs.sh && /opt/hadoop/sbin/stop-yarn.sh
EOF

chmod 700 /opt/start-hh.sh
chmod 700 /opt/stop-hh.sh

tee /etc/systemd/system/hh.service <<EOF
[Unit]
Description=Hadoop && HBase
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=bash /opt/start-hh.sh hadoop1 hadoop2 hadoop3 hadoop4 hadoop5
ExecStop=bash /opt/stop-hh.sh
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