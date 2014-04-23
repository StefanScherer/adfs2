#!/bin/sh

# set limits
cat <<LIMITS | sudo tee -a /etc/security/limits.conf
vagrant          soft    nofile          100000
vagrant          hard    nofile          100000
LIMITS

# install curl-loader from source
sudo apt-get -y install git make
git clone https://github.com/StefanScherer/curl-loader
sudo chown -R vagrant:vagrant curl-loader
cd curl-loader
mkdir obj
make
sudo make install
cd ..

sudo apt-get -y install curl

echo "Now you can start testing in /vagrant/test/curl-loader/ directory."
