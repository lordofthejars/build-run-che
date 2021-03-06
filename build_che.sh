#!/bin/bash

# this script downloads the src and runs the build
# to create the che binaries

. config 

git clone -b ${RH_CHE_GIT_BRANCH} ${RH_CHE_GIT_REPO}

cd rh-che
mkdir $NPM_CONFIG_PREFIX
scl enable rh-maven33 rh-nodejs4 'mvn -B install -U'
if [ $? -ne 0 ]; then
  echo "Error building che/rh-che with dashboard"
  exit 1;
fi
cp target/export/che-dependencies/che/assembly/assembly-main/target/eclipse-che-*.tar.gz ${HomeDir}
cp target/builds/fabric8/fabric8-che/assembly/assembly-main/target/eclipse-che-*.tar.gz ${HomeDir}

scl enable rh-maven33 rh-nodejs4 'mvn -B --activate-profiles=-checkout-base-che -DwithoutDashboard clean install -U'
if [ $? -ne 0 ]; then
  echo "Error building che/rh-che without dashboard"
  exit 1;
fi
cp target/builds/fabric8-without-dashboard/fabric8-che/assembly/assembly-main/target/eclipse-che-*.tar.gz ${HomeDir}
