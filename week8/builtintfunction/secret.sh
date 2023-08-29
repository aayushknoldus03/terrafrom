#!/bin/bash
sudo apt-get update

export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpassword"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpassword"

sudo apt-get -y install mysql-server mysql-client

sudo mysql_secure_installation
