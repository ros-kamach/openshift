#!/bin/bash
LIGHT_GREAN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m'
LOGIN=system:admin
SERVER_IP=$(minishift ip)

if [ "$1" == "apply" ]
    then
        TIME=20
    else
        TIME=0
fi

oc login -u $LOGIN > /dev/null
printf "${RED}################${NC}\n"
printf "Logged as ${LIGHT_GREAN}$LOGIN${NC}\n"
printf "${RED}################\n"
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/rbac.yaml | oc $1 -f -
printf "${RED}Sleep for ${TIME}sec${NC}\n"
sleep $TIME
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/jenkins/jenkins_persistent.yaml  | oc $1 -f -
printf "${RED}Sleep for ${TIME}sec${NC}\n"
sleep $TIME
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_build.yaml  | oc $1 -f -
printf "${RED}Sleep for ${TIME}sec${NC}\n"
sleep $TIME
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_deploy.yaml  | oc $1 -f -
printf "${RED}Sleep for ${TIME}sec${NC}\n"
sleep $TIME
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_mysql.yaml  | oc $1 -f -

printf "${RED}################\n"
printf "${LIGHT_GREAN}The server is accessible via web console at:${NC}\n"
printf "${LIGHT_GREAN}https://${SERVER_IP}:8443/console${NC}\n"
printf "${RED}################${NC}\n"