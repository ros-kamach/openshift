#!/bin/bash
OPENSHIFT_USER=openshift-demo
LIGHT_GREAN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m'
LOGIN=system:admin
SERVER_IP=$(minishift ip)

if [ "$1" == "apply" ]
    then
        TIME=20
        PROCESS=Implementation
    else
        TIME=1
        PROCESS=Removing
fi

oc login -u $LOGIN > /dev/null
printf "${RED}################${NC}\n"
printf "Logged as ${LIGHT_GREAN}$LOGIN${NC}\n"

if [ "$1" == "apply" ]
    then
        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}$PROCESS RBAC on cluster${NC}\n"
        #oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/rbac.yaml | oc $1 -f -
        oc process -f rbac.yaml | oc $1 -f -
        printf "${LIGHT_GREAN}Sleep for ${TIME}sec befoure next step${NC}\n"
        sleep $TIME
fi

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}$PROCESS Jenkins on cluster${NC}\n"
#oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/jenkins/jenkins_persistent.yaml  | oc $1 -f -
oc process -f jenkins/jenkins_persistent.yaml  | oc $1 -f -
printf "${LIGHT_GREAN}Sleep for ${TIME}sec befoure next step${NC}\n"
sleep $TIME

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}$PROCESS Thunder build on cluster${NC}\n"
#oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_build.yaml  | oc $1 -f -
oc process -f thunder/thunder_build.yaml  | oc $1 -f -
printf "${LIGHT_GREAN}Sleep for ${TIME}sec befoure next step${NC}\n"
sleep $TIME

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}$PROCESS Thunder deployment on cluster${NC}\n"
#oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_deploy.yaml  | oc $1 -f -
oc process -f thunder/thunder_deploy.yaml  | oc $1 -f -
printf "${LIGHT_GREAN}Sleep for ${TIME}sec befoure next step${NC}\n"
sleep $TIME

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}$PROCESS MYSQL for Thunder on cluster${NC}\n"
#oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_mysql.yaml  | oc $1 -f -
oc process -f thunder/thunder_mysql.yaml  | oc $1 -f -

if [ "$1" == "delete" ]
    then
        printf "${LIGHT_GREAN}Sleep for ${TIME}sec befoure next step${NC}\n"
        sleep $TIME
        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}$PROCESS RBAC on cluster${NC}\n"
        #oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/rbac.yaml | oc $1 -f -
        oc process -f rbac.yaml | oc $1 -f -
        oc delete identity anypassword:${OPENSHIFT_USER} > /dev/null
    else
        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}The Jenkins wll be accessible via web address at:${NC}\n"
        printf "${LIGHT_GREAN}https://$(oc get route -n jenkins-ci | grep jenkins | awk '{print $2}')${NC}\n"
        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}The Thunder wll be accessible via web address at:${NC}\n"
        printf "${LIGHT_GREAN}https://$(oc get route -n thunder | grep thunder-route | awk '{print $2}')${NC}\n"
fi

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}The server is accessible via web console at:${NC}\n"
printf "${LIGHT_GREAN}https://${SERVER_IP}:8443/console${NC}\n"
printf "${RED}################${NC}\n"