sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 8919F6BD2B48D754

echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

sudo apt-get install -y clickhouse-server clickhouse-client
sudo systemctl enable clickhouse-server --now

# sudo service clickhouse-server start
# sudo systemctl stop clickhouse-keeper
# sudo systemctl stop clickhouse-server


tee -a /etc/hosts <<EOF
192.168.1.49    clickhouse1
192.168.1.35    clickhouse2
192.168.1.66    clickhouse3
192.168.1.42    zookeeper1
192.168.1.71    zookeeper2
192.168.1.34    zookeeper3
EOF



tee /etc/clickhouse-server/config.d/cluster.xml <<EOF
<clickhouse>
    <remote_servers>
        <cluster1>
            <shard>
                <replica>
                    <host>clickhouse1</host>
                    <port>9000</port>
                </replica>
            </shard>
            <shard>
                <replica>
                    <host>clickhouse2</host>
                    <port>9000</port>
                </replica>
                <replica>
                    <host>clickhouse3</host>
                    <port>9000</port>
                </replica>
            </shard>
        </cluster1>
    </remote_servers>
</clickhouse>
EOF

tee /etc/clickhouse-server/config.d/zookeeper.xml <<EOF
<clickhouse>
    <zookeeper>
        <node>
            <host>zookeeper1</host>
            <port>2181</port>
        </node>
        <node>
            <host>zookeeper2</host>
            <port>2181</port>
        </node>
        <node>
            <host>zookeeper3</host>
            <port>2181</port>
        </node>
        <session_timeout_ms>30000</session_timeout_ms>
        <operation_timeout_ms>10000</operation_timeout_ms>
    </zookeeper>
    <!-- Allow to execute distributed DDL queries (CREATE, DROP, ALTER, RENAME) on cluster. -->
    <!-- Works only if ZooKeeper is enabled. Comment it out if such functionality isn't required. -->
    <distributed_ddl>
        <!-- Path in ZooKeeper to queue with DDL queries -->
        <path>/clickhouse/task_queue/ddl</path>
        <!-- Settings from this profile will be used to execute DDL queries -->
        <!-- <profile>default</profile> -->
    </distributed_ddl>
</clickhouse>
EOF

tee /etc/clickhouse-server/config.d/remote-access.xml <<EOF
<clickhouse>
    <listen_host>::</listen_host>
</clickhouse>
EOF

## =======================

tee /etc/clickhouse-server/config.d/macros.xml <<EOF
<clickhouse>
    <macros>
        <shard>01</shard>
        <replica>01</replica>
    </macros>
</clickhouse>
EOF

sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server

## =======================

tee /etc/clickhouse-server/config.d/macros.xml <<EOF
<clickhouse>
    <macros>
        <shard>02</shard>
        <replica>01</replica>
    </macros>
</clickhouse>
EOF

sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server

## =======================

tee /etc/clickhouse-server/config.d/macros.xml <<EOF
<clickhouse>
    <macros>
        <shard>02</shard>
        <replica>02</replica>
    </macros>
</clickhouse>
EOF





sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server

sudo systemctl start clickhouse-keeper
sudo systemctl status clickhouse-keeper

clickhouse-client -q "SELECT * FROM system.clusters WHERE cluster='cluster1' FORMAT Vertical;"

"
CREATE DATABASE IF NOT EXISTS example_DB ON CLUSTER 'cluster1';

CREATE TABLE example_DB.product ON CLUSTER 'cluster1'
               (
               created_at DateTime,
               product_id UInt32,
               category UInt32
               ) ENGINE = ReplicatedMergeTree('/clickhouse/tables/cluster1/02/example_DB/product', '02')
               PARTITION BY toYYYYMM(created_at)
               ORDER BY (product_id, toDate(created_at), category)
               SAMPLE BY category;

CREATE TABLE example_DB.product2 ON CLUSTER 'cluster1'
                              (
                              created_at DateTime,
                              product_id UInt32,
                              category UInt32
                              ) ENGINE = ReplicatedMergeTree()
                              PARTITION BY toYYYYMM(created_at)
                              ORDER BY (product_id, toDate(created_at), category)
                              SAMPLE BY category;


insert into example_DB.product2 (now(), 1, 1);
"