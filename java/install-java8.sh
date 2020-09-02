#!/bin/sh

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
fi

if [ $OS == 'centos' ]; then
  sudo yum -y install java-1.8.0-openjdk
	sudo yum -y install java-1.8.0-openjdk-devel.x86_64
elif [ $OS == 'ubuntu'  ]; then
  sudo apt-get install -y java-1.8.0-openjdk
	sudo apt-get install -y java-1.8.0-openjdk-devel.x86_64
fi


JAVA_VERSION="$(java -version 2>&1)"
if [[ ($JAVA_VERSION == "open"*) || ($JAVA_VERSION == "Open"*) ]]; then
  echo "Java installed correctly."
  read -p "Export JAVA_HOME to PATH? (y/n)" export
  if [ $export == "y" ]; then
    JAVA_PATH="$(sudo alternatives --config java | grep -Po '\(\K[^)]*' 2>&1)"
    export JAVA_HOME="${JAVA_PATH::-8}"
    sudo sh -c "echo export JAVA_HOME=$JAVA_HOME >> /etc/environment"
    echo "Exported JAVA_HOME variable for all users"
	fi
fi