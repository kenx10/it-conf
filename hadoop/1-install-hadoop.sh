# устанавливаем основные инструменты (на всех узлах кластера)
sudo apt update
sudo apt install default-jdk mc

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.4.0/hadoop-3.4.0.tar.gz
tar -xzvf hadoop-3.4.0.tar.gz
mv hadoop-3.4.0 /opt/hadoop

# генерим ключевые пары для того, чтобы любой хост мог обратиться к любому по ssh (на всех узлах кластера)
ssh-keygen -t rsa -b 4096 -C "hadoop@evg299.ru" -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub

tee ~/.ssh/authorized_keys <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDXIYlhbOCiB46Twrmzh3D5N/o8QnDmwEWlaHfoLo2Ot evgeny@evgeny-z97
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjstuf6XC3ugTntaeK1slOQSxMIguYoIGcYcs3bHs9NnNZy79z9wIly86z5ByNLBOY8ZP7kSyA6L6J5KykTXufayVSjCLqfEKqJyGkm5UspvpHZoAsRZLn15TYtGHS7MJEfAffJCmgRpnrW/rKkcOTZco3cvzVUIBBsFZvYAS8SHh6xdhRaEQWS7CnS5NHtX0QavJ/jLW6B/bfh3u+atJ6IONer35jNMwCExo+erZA16GILL69/sojXHlIjWCzrWQRWdtYgCxJWRcs9f7OvtDmtqZ4QaY33BjUTQzkyt4SR8FHX02E9wmt5mzgNVBDKANPhAlccrWUYLCDJQWium4u8wpQ0QlsePs8NitlaJtl08zC+AQSIszPhszNks/xvnuEUMIBDuCFDZwXxjusE0q3wtpDyQwkR1c6HYgkMYLwPUTr4XcIEOeuOOnuuo4b2weqBhipiAgd/vo6mjf5R5m3fZ6j61UGDPtjN90hHWg8IPCvSGG79ycBxcECo4nH0C44JzsgmFi0XEOOR4O+fFForvHC5GZXR5Mhddw2zsz6lDFRGKnClUuKPAmFYJjawbXfBmL4PxrIqE5GWJ7pvb4PbVChnPAjIfjV04oNpVaHEkn9e8CncfNFoM9yMkKGgZ1K1FtSSRxq3kgOnIphmSAIPXhBSg2WILHftRWwDRaDPw== hadoop@evg299.ru
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC582INvVjAjp9C5izTSi6rIAoORPQzJAf+8dPJRAiM4itKnl5uOhFZRSZVb6y8/wy8dkIRxMEKwxTvS9zNmWu4sUbYBE39pxx5PaFtha53Ok07X7tbMhaqTwGkShzh8YmTP2jNwahQfLkpTRbiu/jB3C2dlWgxqVyLa7i8pgco9koDzZr7ctvXGZvTBFqqeRNPiUFDzokRLUL3v8t1VddZCcx9VW9o/mU/lzD9wdzLrjKsFvzsfRb/JscVUHVnmSpDtNYqkK6p4oRj4qZcSbLexkIpdDPLOfNrZiDeUBzUmC7vMUrPJWqgud6jcDV2CnYUH4k+oeTD/wVrDF+9+iA5ZzyitR1tDhUkvrUMKHH2UeyoId7LKlwOL1YY6Qjba85+qHPp9FEkG2YCVMIXlRPberoT97cI96ibTrfWivXyYKZ7qaDGWYIPbQsikWQ6QVXzLT6N4BQJ3upaKU+CuOvrED7n2cVm5NNMa7GYEzGcTai1aIpniXeX5TgpC05PjtEGVzigaXxwPEud+leC1zUBqsonAKxA+SxK9Rd9IDQnetv/IADDE8eIguersfpihsiudl9IgclkVxt6M0lNk1PJvLQM41Dau8E6HolRJGcXft2KPtgch79VX0rDUs5XrenvHzDPlRcnoP7uJRUcxzSjXhCZj69zHt0/rqdmbgp+Ew== hadoop@evg299.ru
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDuqvv5c2bKLwZvehbijwWb+OCtrnPoiNLl67RcB0QlpK/O8WfDKVUtmQPNaMTvYfQRNMPWFb/RhBUFtODU/W2J59jLXbz2RQPcSwL7zdCTUBdkPv7DlSSeuD17Fb1b5AjsR5WNV0v0yjGwN/COae29KgozaqLgj5fyuyEP08ZGg+UP/OmLmiVfMK7C+PLTdRThLm212KSTegwxUqHml5AAQ9wteCgXgZKEkXXAjo1AF+fvSgQjejd50GJZV/+gLYeiH/a1YKDWMefBPoX90IhUJ0qLwsux/Usp6BSwleIECVtkd16wQp1Q23B3PAxH5Lctqayt6nwHxU9lmQJaVMsFkC10RD59Y3p10TH5ms3G5Jj2PAyrgf3Dk0J5sEsUgK4OocUtWIerXhg1fQw7SR76GA24td1vUnzlQYU+AF4eAHYHV/jLYcHD3YhYnxm9B6w9x6ASuJH6gv1VbJp4j6E8hw+G3yyYSkFDixNrzZPqNqyt8o7U4p39OLRAWwzJDsYHgyHl07+6LJ6JwIUqzazo7uHw/6pn0SiHJwNWyPu7Li8X2+g0cV1H94Dy1EtUXIJMmQ42RgEWHrysgW5j3ERSD6B30/b5rizq+bzbl4SlhM/8FO4zofawQHgddqkp8w+nHfewk6qwEKtPuf3jSO7idleWBQ8gaj+z0XffJkvbtw== hadoop@evg299.ru
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwtyOm4KdU8QZuQ0689y1IgoxIN54et296E5J43g+fvZ3/6UPgk7GN86TQa/bVfxW/rdW0ogQrIRGGeWkVnSbA48umky0QaHiHHJU2CpSOTwRXUR0hgWUqKXllb154+V48rh/bRATP8EITvFPEswFrgoveWb+3bjiGO4CHOqsHvBoRFhwWRUX0Ku3itZNg+94J6hwHJB0mXU8H6VR/ApGYp2rIU47dR3KRdous44Ta9UjJ41zqRlPrUL6AtPjtSX9pDx0L5/MXbr2hCgexdn4WiSiXMHukztoDcDOkZ2xG9S4OoClMWxSKm4ch6hbuMhReUE7CDqvbThcUcCkOtS6hnNWiNfGopvsbH/YFt1qhxNx+8nouwih74K2UVy6FsK+FRuDwa7/aw7pyVUx1UF9bUsDqiGL+1N3m5THll/Plwa3luV9J66YfxYrQNyxSgYnrHQaniWx0psosgD5YU7xmgcsirciGGZ/JbaA3QeLSHQV0fUbCfi4GkwKXa950v6P/gQlGhO/uj6ylgslHeaXLCaPpXzmySlYTyOs81WyTzeqBLUMc+CNnsgkl9UU+Lx9HjbvhfS+lkKVS3pgyipdRWxjlKVla+odxnUKN92VG+PxTjxPPom51otqGrZ7RJ3rLXv/SlMa/cy+igGLbDu3jAYTGu76mW8R3c8DjaPR8yw== hadoop@evg299.ru
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCc6f4Vy+TCvcOkUwPGpyLvpF1lOHUxUyC0iwsXz0y1cSrqgr4oRSft7RE+2QUP9TtAzsg0AhkUVauq9YLmQXawNn3JAiX2UDdyH6tHLADk4viCRaJCah/JtBYLqzvEt1xHIECzg4j6HPed6NB8j6LYhzKno56mIW9urQHOHeSXJ+vknk5YXQuNOZXY/8lMp2GPBo8uDQcfqLlHpsYSRayJMXlTdRBVc61XyIBERUkqX/xU9Ew28v0huHlY/CKds7yxYO/UHmcKnxmG+Lrie/Shy7PJejHL1p6XJbylC1YgdRiRXUaD92pdNLXEMy5fjRD3gzXz5zHlWwfJ9gLK+qk8uvo51zO74ljszWvN2Xs6h6ZP0iFhuXvRxHpCdfG8ftFVnbic0oWTU/CNkSyHSuhcfOKb+e0+WPv56kgoVAV8ZMCsdlu96w7jnNKs38zYaEY0IjUao7SvXTxnBaDXPbOGJixm2gLKyOzopPxwGheCJVYU/giCXoo61aCKPfmwiIqI2GT2ZZ8JXgSuwPLpbXCbRoGNLb+C1ay7HtOmirp/qxeV/d011IJ2ug2nSWDyDtqNDcVklwTDTKBvjQILJFsByhU2k9EkKuhHg49S3hBSxn4WOjhDikgGUT5B28bIfU7vNVmlYB79ZxbHyqivJThJzU5Vz8Ycl0ZqgYHqLXyG+Q== hadoop@evg299.ru
EOF

# проставляем имена хостов (на всех узлах кластера)
tee /etc/hosts <<EOF
127.0.0.1 localhost

::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

192.168.1.51    hadoop1
192.168.1.57    hadoop2
192.168.1.44    hadoop3
192.168.1.67    hadoop4
192.168.1.38    hadoop5

192.168.1.54    zookeeper1
192.168.1.45    zookeeper2
192.168.1.68    zookeeper3
EOF

# nano ~/.ssh/authorized_keys
# ssh-copy-id root@hadoop1

# ===========================================
# добавляем переменные среды (на всех узлах кластера)
tee -a ~/.bashrc <<EOF
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
HADOOP_HOME=/opt/hadoop

export JAVA_HOME
export HADOOP_HOME

export PATH=\$PATH:\${HADOOP_HOME}/bin
export PATH=\$PATH:\${HADOOP_HOME}/sbin
export HADOOP_MAPRED_HOME=\${HADOOP_HOME}
export HADOOP_COMMON_HOME=\${HADOOP_HOME}
export HADOOP_HDFS_HOME=\${HADOOP_HOME}
export YARN_HOME=\${HADOOP_HOME}
EOF

source ~/.bashrc

# создаем рабочую директорию (на всех узлах кластера)
sudo mkdir -p /hdfs/data
chmod 700 /hdfs/data

# конфигурируем hadoop (на всех узлах кластера)

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
hadoop1
hadoop2
hadoop3
hadoop4
hadoop5
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



# если не стартует после добавления узла
rm -Rf /tmp/hadoop-root
rm -Rf /hdfs/data/dataNode

hdfs namenode -format