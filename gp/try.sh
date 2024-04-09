# not work
wget https://github.com/greenplum-db/gpdb/archive/refs/tags/6.26.4.tar.gz
tar -zxvf 6.26.4.tar.gz
cd gpdb-6.26.4

sudo apt-get install build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache pkg-config libzstd1 libipc-run-perl


sudo ln -s /usr/bin/krb5-config.mit /usr/bin/krb5-config
sudo ln -s /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 /usr/lib/libgssapi_krb5.so
sudo apt-get install python3-pip libkrb5-dev
sudo pip install gssapi

sudo apt-get install libapr1 libapr1-dev libevent-dev

./configure --with-perl --with-python --with-libxml --with-gssapi --prefix=/usr/local/gpdb