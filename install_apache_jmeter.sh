#!/usr/bin/env bash
set -ex

# Install Apache JMeter
apt update
apt install openjdk-17-jdk -y
cd /opt
wget -O apache-jmeter.tgz "https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz"
tar xvf apache-jmeter.tgz
rm -rf apache-jmeter.tgz
mv apache-jmeter-5.6.3 apache-jmeter

chown -R 1000:1000 /opt/apache-jmeter 

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
fi
