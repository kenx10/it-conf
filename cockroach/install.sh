# https://vitux.com/how-to-deploy-secure-cockroachdb-cluster-on-ubuntu/
# https://www.tecmint.com/install-cockroachdb-on-ubuntu/
apt-get update -y
apt-get install chrony -y

# install cockroach (all nodes)
wget https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
tar -xvzf cockroach-latest.linux-amd64.tgz
cp cockroach-*/cockroach /usr/local/bin/

cockroach version

###### Start insecure
sudo tee /etc/systemd/system/cockroach.service <<EOF
[Unit]
Description=CockroachDB
Documentation=https://www.cockroachlabs.com/docs/
After=network.target

[Service]
Type=notify
ExecStart=/usr/local/bin/cockroach start --insecure --listen-addr=192.168.1.92:26257 --http-addr=192.168.1.92:8080 --join=192.168.1.92:26257,192.168.1.73:26257,192.168.1.129:26257
TimeoutStartSec=0
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

#
sudo tee /etc/systemd/system/cockroach.service <<EOF
[Unit]
Description=CockroachDB
Documentation=https://www.cockroachlabs.com/docs/
After=network.target

[Service]
Type=notify
ExecStart=/usr/local/bin/cockroach start --insecure --listen-addr=192.168.1.73:26257 --http-addr=192.168.1.73:8080 --join=192.168.1.92:26257,192.168.1.73:26257,192.168.1.129:26257
TimeoutStartSec=0
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

#
sudo tee /etc/systemd/system/cockroach.service <<EOF
[Unit]
Description=CockroachDB
Documentation=https://www.cockroachlabs.com/docs/
After=network.target

[Service]
Type=notify
ExecStart=/usr/local/bin/cockroach start --insecure --listen-addr=192.168.1.129:26257 --http-addr=192.168.1.129:8080 --join=192.168.1.92:26257,192.168.1.73:26257,192.168.1.129:26257
TimeoutStartSec=0
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

#
sudo systemctl daemon-reload
sudo systemctl start cockroach
sudo systemctl enable cockroach
sudo systemctl status cockroach


###
cockroach init --insecure --host=192.168.1.92:26257
cockroach node status --insecure --host=192.168.1.92:26257


# default user - root










####################################

# CA Certificates
mkdir ~/certs
cockroach cert create-ca --certs-dir=certs --ca-key=certs/ca.key

# copy certs to local, mk dirs
scp ~/certs/ca.crt ~/certs/ca.key root@192.168.1.73:~/certs/
scp ~/certs/ca.crt ~/certs/ca.key root@192.168.1.129:~/certs/

# Client Certificate
cockroach cert create-client root --certs-dir=certs --ca-key=certs/ca.key

# Server Certificates
cockroach cert create-node localhost $(hostname) 192.168.1.92 --certs-dir=certs --ca-key=certs/ca.key
cockroach cert create-node localhost $(hostname) 192.168.1.73 --certs-dir=certs --ca-key=certs/ca.key
cockroach cert create-node localhost $(hostname) 192.168.1.129 --certs-dir=certs --ca-key=certs/ca.key


cockroach cert create-node localhost cockroach1 192.168.1.92 --certs-dir=/root/certs --ca-key=/root/certs/ca.key
cockroach node status --certs-dir=/root/certs --host=192.168.1.92
