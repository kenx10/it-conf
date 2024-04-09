# sudo apt-get --purge remove postgresql postgresql-*
# dpkg -l | grep postgres

sudo apt update
sudo apt install postgresql mc

systemctl status postgresql

su - postgres
psql -c "ALTER ROLE postgres PASSWORD '5286856290'"
exit

tee -a /etc/hosts <<EOF
192.168.1.60    postgres1
192.168.1.59    postgres2
192.168.1.36    postgres3
EOF

systemctl stop postgresql

tee -a /etc/postgresql/12/main/postgresql.conf <<EOF
listen_addresses = '*'
wal_level = replica
max_wal_senders = 3
max_replication_slots = 3
hot_standby = on
hot_standby_feedback = on
EOF
# nano /etc/postgresql/12/main/postgresql.conf

tee -a /etc/postgresql/12/main/pg_hba.conf <<EOF
host    all             postgres             192.168.1.0/24               md5
EOF
# nano /etc/postgresql/12/main/pg_hba.conf

systemctl restart postgresql
systemctl enable postgresql




