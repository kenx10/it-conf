sudo apt update
sudo apt install postgresql mc

systemctl status postgresql

tee -a /etc/hosts <<EOF
192.168.1.60    postgres1
192.168.1.59    postgres2
192.168.1.36    postgres3
EOF

systemctl stop postgresql


############################

tee -a /etc/postgresql/12/main/postgresql.conf <<EOF
listen_addresses = '*'
EOF

tee -a /etc/postgresql/12/main/pg_hba.conf <<EOF
host    all             postgres             192.168.1.0/24               md5
EOF

rm -rf /var/lib/postgresql/12/main;
su - postgres -c "cd /var/lib/postgresql/12/; mkdir main; chmod go-rwx main; pg_basebackup -h postgres1 -D ./main -U postgres -v -P -R --wal-method=stream"
# 5286856290

systemctl restart postgresql
systemctl enable postgresql

su - postgres -c "psql"