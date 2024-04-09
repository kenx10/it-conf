# for all
sudo apt update
sudo apt install default-jdk mc

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
tar -xzvf hadoop-3.4.0.tar.gz
mv hadoop-3.4.0 /opt/hadoop

ssh-keygen -t rsa -b 4096 -C "hadoop@evg299.ru" -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub

tee -a /etc/hosts <<EOF
192.168.1.51    hadoop1
192.168.1.57    hadoop2
192.168.1.44    hadoop3
EOF

nano ~/.ssh/authorized_keys

# ssh-copy-id root@hadoop1
# ssh-copy-id root@hadoop2
# ssh-copy-id root@hadoop3

# ===========================================

tee -a ~/.bashrc <<EOF
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
HADOOP_HOME=/opt/hadoop

export JAVA_HOME
export HADOOP_HOME

export PATH=$PATH:${HADOOP_HOME}/bin
export PATH=$PATH:${HADOOP_HOME}/sbin
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
EOF

source ~/.bashrc

sudo mkdir -p /hdfs/data
chmod 700 /hdfs/data

# ===========================================

tee -a /opt/hadoop/etc/hadoop/hadoop-env.sh <<EOF
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"
EOF

tee /opt/hadoop/etc/hadoop/core-site.xml <<EOF
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://hadoop1:9000</value>
    </property>
</configuration>
EOF

tee /opt/hadoop/etc/hadoop/hdfs-site.xml <<EOF
<configuration>
    <property>
        <name>dfs.secondary.http.address</name>
        <value>hadoop2:50090</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/hdfs/data/nameNode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/hdfs/data/dataNode</value>
    </property>
</configuration>
EOF

tee /opt/hadoop/etc/hadoop/yarn-site.xml <<EOF
<configuration>
        <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>hadoop1</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
            <value>org.apache.hadoop.mapred.ShuffleHandler</value>
        </property>
</configuration>
EOF

tee /opt/hadoop/etc/hadoop/workers <<EOF
hadoop2
hadoop3
EOF

tee /opt/hadoop/etc/hadoop/mapred-site.xml <<EOF
<configuration>
    <property>
        <name>mapreduce.jobtracker.address</name>
        <value>hadoop1:54311</value>
    </property>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF





# ====== master ======
hdfs namenode -format
# start-dfs.sh
# start-all.sh


tee /etc/systemd/system/hadoop-all.service <<EOF
[Unit]
Description=Hadoop All
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/hadoop/sbin/start-all.sh
ExecStop=/opt/hadoop/sbin/stop-all.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# ===========================================

sudo systemctl daemon-reload
sudo systemctl enable hadoop-all

sudo systemctl start hadoop-all
sudo systemctl status hadoop-all

sudo systemctl disable hadoop-all

# ===========================================

tee /etc/systemd/system/hadoop-resourcemanager.service <<EOF
[Unit]
Description=Hadoop ResourceManager
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/hadoop/sbin/yarn-daemon.sh start resourcemanager
ExecStop=/opt/hadoop/sbin/yarn-daemon.sh stop resourcemanager
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# ===========================================

tee /etc/systemd/system/hadoop-nodemanager.service <<EOF
[Unit]
Description=Hadoop NodeManager
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/opt/hadoop/sbin/yarn-daemon.sh start nodemanager
ExecStop=/opt/hadoop/sbin/yarn-daemon.sh stop nodemanager
Restart=always

[Install]
WantedBy=multi-user.target
EOF