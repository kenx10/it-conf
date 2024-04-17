# устанавливаем phoenix (на всех узлах кластера)

wget https://dlcdn.apache.org/phoenix/phoenix-5.1.3/phoenix-hbase-2.5-5.1.3-bin.tar.gz
tar -xzvf phoenix-hbase-2.5-5.1.3-bin.tar.gz
mv phoenix-hbase-2.5-5.1.3-bin /opt/phoenix-hbase

tee -a ~/.bashrc <<EOF
PHOENIX_HOME=/opt/phoenix-hbase
export PHOENIX_HOME
export PATH=\$PATH:\${PHOENIX_HOME}/bin
EOF

# nano ~/.bashrc
source ~/.bashrc

# Добавляем конфигурацию для phoenix
tee /opt/hbase/conf/hbase-site.xml <<EOF
<configuration>
    <!-- Конфигурация ZooKeeper -->
    <property>
        <name>hbase.zookeeper.quorum</name>
        <value>zookeeper1, zookeeper2, zookeeper3</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.clientPort</name>
        <value>2181</value>
    </property>
    <property>
            <name>hbase.zookeeper.property.dataDir</name>
            <value>/export/zookeeper</value>
    </property>


    <!-- Расположение данных HBase -->
    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://hadoop1:9000/hbase</value>
    </property>
    <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>


    <!-- Расположение логов HBase -->
    <property>
        <name>hbase.regionserver.wal.dir</name>
        <value>/hbase/wal</value>
    </property>

    <!-- Конфигурация репликации -->
    <property>
        <name>hbase.region.replica.replication.enabled</name>
        <value>true</value>
    </property>

    <!-- Конфигурация для phoenix -->
    <property>
        <name>hbase.regionserver.wal.codec</name>
        <value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value>
    </property>
</configuration>
EOF

# Делаем org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec доступным hbase (он в phoenix-server-hbase-2.5-5.1.3.jar)
cp -rf "$PHOENIX_HOME"/phoenix-server-hbase-2.5-5.1.3.jar "$HBASE_HOME"/lib




# Тестируем
sudo ln -s /usr/bin/python3 /usr/bin/python

sqlline.py zookeeper1,zookeeper2,zookeeper3
#!tables

sqlline.py zookeeper1,zookeeper2,zookeeper3 /opt/phoenix-hbase/examples/STOCK_SYMBOL.sql