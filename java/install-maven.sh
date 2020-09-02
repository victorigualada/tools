#!/bin/sh

findLastMavenVersion() {
  IMG_TAG="<img"
  BEFORE_VERSION_STR='<img src="/icons/folder.gif" alt="[DIR]"> <a href="'
  BEFORE_VERSION_LEN=${#BEFORE_VERSION_STR}
  VERSION_NUMBER_LEN=5

  IFS=$'\r\n' GLOBIGNORE='*' command eval  'VERSIONS=($(curl -s "http://www-us.apache.org/dist/maven/maven-3/"))'
  LAST_MVN_VERSION=0
  for line in "${VERSIONS[@]}"
  do
          if [[ $line = $IMG_TAG*  ]]
          then
                  LAST_MVN_VERSION=$(echo ${line:$BEFORE_VERSION_LEN:$VERSION_NUMBER_LEN})

          fi
  done
  echo "$LAST_MVN_VERSION"
}

centosInstall() {
  MVN_VERSION=$(findLastMavenVersion)
  cd /usr/local/src
  if [ -d apache-maven  ]; then
          rm -rf apache-maven
  fi
  wget http://www-us.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
  sudo tar -zxvf /usr/local/src/apache-maven-$MVN_VERSION-bin.tar.gz -C .
  rm apache-maven-$MVN_VERSION-bin.tar.gz
  mv apache-maven-*/ /usr/local/src/apache-maven/
  rm -rf apache-maven-*/
}

configureCentosEnvironment() {
  cd /etc/profile.d/
  rm maven.sh
  echo "# Apache Maven Environment Variables
        # MAVEN_HOME for Maven 1 - M2_HOME for Maven 2
        export M2_HOME=/usr/local/src/apache-maven
        export PATH=\${M2_HOME}/bin:\${PATH}" >> maven.sh
  chmod +x maven.sh
  source /etc/profile.d/maven.sh
}

if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
fi

if [ $OS == 'centos' ]; then
  echo "Installing Maven on CentOS"
  centosInstall
  configureCentosEnvironment
elif [ $OS == 'ubuntu'  ]; then
  echo "Installing Maven on Ubuntu"
  sudo apt-get install -y maven
fi