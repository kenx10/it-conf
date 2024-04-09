# gitlab vm
# better use k8s
sudo apt update
sudo apt install ca-certificates curl openssh-server postfix

cd /tmp
curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
sudo bash script.deb.sh

sudo apt install gitlab-ce

sudo ufw allow http
sudo ufw allow https

sudo cat /etc/gitlab/initial_root_password

#-----------------------------

#- worker

# curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
# sudo apt-get install gitlab-runner
# sudo gitlab-runner -version
# sudo gitlab-runner status

# gitlab-runner register  --url http://gitlab  --token glrt-YLx4Qoxx8fq3YPJKq1f2

# docker worker
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

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


docker run -d --name gitlab-runner-maven --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config:/etc/gitlab-runner \
    gitlab/gitlab-runner:latest

docker exec -it gitlab-runner gitlab-runner register

# http://192.168.1.50
# glrt-YLx4Qoxx8fq3YPJKq1f2
# docker
# maven:3-openjdk-17
