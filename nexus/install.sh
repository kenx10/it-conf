sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin

#-------------

docker run -d -p 8081:8081 --name nexus --restart=always  -v /srv/nexus/nexus-data:/nexus-data sonatype/nexus3
chown -R 200:200 /srv/nexus/
docker restart nexus

cat /srv/nexus/nexus-data/admin.password


#-------------
#------OR-----
#-------------

sudo apt update
sudo apt upgrade
sudo apt install openjdk-8-jre-headless
sudo adduser --disabled-login --no-create-home --gecos "" nexus

cd /opt
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -zxvf latest-unix.tar.gz

cd /opt
sudo mv nexus-3.66.0-02/ nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

#----
sudo nano /opt/nexus/bin/nexus.rc
# Add the following line:
run_as_user="nexus"

#----
sudo nano /opt/nexus/bin/nexus.vmoptions

-Xms1024m
-Xmx1024m
-XX:MaxDirectMemorySize=1024m
-XX:LogFile=./sonatype-work/nexus3/log/jvm.log
-XX:-OmitStackTraceInFastThrow
-Djava.net.preferIPv4Stack=true
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc/karaf
-Djava.util.logging.config.file=/etc/karaf/java.util.logging.properties
-Dkaraf.data=./sonatype-work/nexus3
-Dkaraf.log=./sonatype-work/nexus3/log
-Djava.io.tmpdir=./sonatype-work/nexus3/tmp

#----
sudo nano /etc/systemd/system/nexus.service

[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target


#----
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus


cat /opt/nexus/sonatype-work/nexus3/admin.password
