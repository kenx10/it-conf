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

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose


sudo apt-get install mc


sudo echo "192.168.1.42    kafka1" >>/etc/hosts
sudo echo "192.168.1.71    kafka2" >>/etc/hosts
sudo echo "192.168.1.34    kafka3" >>/etc/hosts

sudo echo "192.168.1.42    zookeeper1" >>/etc/hosts
sudo echo "192.168.1.71    zookeeper2" >>/etc/hosts
sudo echo "192.168.1.34    zookeeper3" >>/etc/hosts
