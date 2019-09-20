#!/bin/bash

#For Run Script write <*.sh> <jenkins_project> <thunder_proje> <apply or delete>
## exampl # bash project.sh jenkins-ci thunder

#######################################
############## Enviroment #############
#######################################

OPENSHIFT_USER=openshift-demo
LIGHT_GREAN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m'
LOGIN=system:admin
SERVER_IP=$(minishift ip)
PROJECT_NAME_JENKINS=$1
PROJECT_NAME_THUNDER=$2

RBAC_FILE="rbac.yaml"
JENKINS_FILE="jenkins/jenkins_persistent.yaml"
THUNDER_BUILD_FILE="thunder/thunder_build.yaml"
THUNDER_DEPLOY_FILE="thunder/thunder_deploy.yaml"
THUNDER_PIPELINE_FILE="thunder/thunder_pipeline.yaml"
MYSQL_DEPLOY_FILE="thunder/thunder_mysql.yaml"

# RBAC_FILE="rbac.yaml"
# JENKINS_FILE="jenkins/jenkins_persistent.yaml"
# THUNDER_BUILD_FILE="thunder/thunder_build.yaml"
# THUNDER_DEPLOY_FILE="thunder/thunder_deploy.yaml"
# THUNDER_PIPELINE_FILE="thunder/thunder_pipeline.yaml"
# MYSQL_DEPLOY_FILE="thunder/thunder_mysql.yaml"

#######################################
######## Function: Alloved ARGS ########
#######################################

check_args () {
case $4 in
  (apply|delete) ;; # OK
  (*) printf >&2 "Wrong arg.${2}${4}${3}. Allowed are ${1}apply${3} or ${1}delete${3} \n"; exit 1;;
esac
}
#######################################
######### Function: YES/NO #############
#######################################

provision_yes_no () {
while true; do
    read -p "yes(Yy) to process or no(Nn) to skip Template : " yn
    case $yn in
        [Yy]* ) if [ "$4" == "apply" ]
                    then
                        oc process -f ${1} -p JENKINS_PROJECT_NAME=${2} -p THUNDER_PROJECT_NAME=${3} | oc ${4} -f - 
                        printf "${6}Sleep for ${8} sec befoure next step ${7}\n"
                        sleep ${8}
                    else
                        oc process -f ${1} -p JENKINS_PROJECT_NAME=${2} -p THUNDER_PROJECT_NAME=${3} | oc ${4} -f -
                fi;break;;
        [Nn]* ) printf "${5}Step Skipped!!!${7}\n";break;;
        * )     echo "Please answer yes(Yy) to process or no(Nn) to skip Template.";;
    esac
done
}

#######################################
### Function: Approve process Name ####
#######################################

approve_yes_no_other () {
while true; do
        if [ "$4" == "apply" ]
            then
                printf "Checking namespases: $6 and $7 for exists\n"
                printf "If it exest script will generate new namespases\n"
                printf "${1}Basic value exist, generated name for Jenkins${3}: ${2}${4}${3}\n"
                printf "${1}Basic value exist, generated name for Thunder${3}: ${2}${5}${3}\n"
            else
                printf "${1}Project name for Jenkins${3}: ${2}${4}${3}\n"
                printf "${1}Project name for Thunder${3}: ${2}${5}${3}\n"
        fi
    printf "${2}Continue with names as above:${3}\n"
    read -p "yes(Yn) to process with names as above / no(Nn) to process with basic values  / exit(Xx) to exit script  : " yno
    case $yno in
        [Yy]* ) break;;
        [Nn]* ) JENKINS_PROJECT_NAME=$6
                THUNDER_PROJECT_NAME=$7;break;;
        [Xx]* ) exit;;
        * ) echo "Please answer yes to use project names:"
            echo "";;
    esac
done
}

#######################################
########## Function: Process ##########
#######################################

process_func () {
        printf "${1}################${2}\n"
        printf "${3}${4} ${7} on cluster${2}\n"
        TIME=30
        if [[ "$( oc process -f ${8} -p JENKINS_PROJECT_NAME=${5} -p THUNDER_PROJECT_NAME=${6} | oc apply --dry-run=true --validate -f - | grep configured )" ]]
            then
                        printf "${1}################${2}\n"
                        printf "${3}This Resourses exists !!!${2}\n"
                        printf "${1}################${2}\n"
                        oc process -f ${8} -p JENKINS_PROJECT_NAME=${5} -p THUNDER_PROJECT_NAME=${6} | oc  apply --dry-run=true --validate -f - | grep configured
                        printf "${1}################${2}\n"
                        printf "${3}Do you want to ${9} it?${2}\n"
                        printf "${1}################${2}\n"
                        provision_yes_no ${8} ${5} ${6} ${9} ${3} ${1} ${2} ${TIME}
            else
                if [ "$9" == "apply" ]
                    then
                        oc process -f ${8} -p JENKINS_PROJECT_NAME=${5} -p THUNDER_PROJECT_NAME=${6} | oc  apply --dry-run=false --validate -f -
                        printf "${1}Sleep for ${TIME} sec befoure next step ${2}\n"
                        sleep ${TIME}
                    else
                        echo "There are nothing to delete"
                fi
                    # oc process -f ${8} -p JENKINS_PROJECT_NAME=${5} -p THUNDER_PROJECT_NAME=${6} | oc ${9} -f -
                    # TIME=30
                    # if [ "$9" == "apply" ]
                    #     then 
                    #         printf "${6}Sleep for ${TIME} sec befoure next step ${7}\n"
                    #         sleep ${TIME}
                    # fi
        fi 
}

#######################################
############### Login #################
#######################################

eval $(minishift oc-env)
oc login -u $LOGIN > /dev/null
printf "${RED}################${NC}\n"
printf "Logged as ${LIGHT_GREAN}$LOGIN${NC}\n"

#######################################
########## Start Implementation #######
#######################################

#Check project Names

check_args ${LIGHT_GREAN} ${RED} ${NC} ${3}

if [ "$3" == "apply" ]
    then
        PROCESS=Implementation
        check_project_exist () {
        PROJECT=$1
            if [[ "$( oc get projects | grep -w $PROJECT | awk '{print $1}' )" ]]
                then
                    i=1
                    while [[ "$PROJECT-$i" == "$( oc get projects | grep -w $PROJECT-$i | awk '{print $1}' )" ]] ; do
                    let i++
                    done
                    PROJECT="$PROJECT-$i"
                else
                    PROJECT="$PROJECT"
            fi
        echo $PROJECT
        }

        JENKINS_PROJECT_NAME=$(check_project_exist ${PROJECT_NAME_JENKINS})
        THUNDER_PROJECT_NAME=$(check_project_exist ${PROJECT_NAME_THUNDER})
        approve_yes_no_other ${LIGHT_GREAN} ${RED} ${NC} ${JENKINS_PROJECT_NAME} ${THUNDER_PROJECT_NAME} $1 $2
        printf "${LIGHT_GREAN}Process with project name for Jenkins${NC}: ${RED}${JENKINS_PROJECT_NAME}${NC}\n"
        printf "${LIGHT_GREAN}Process with project name for Thunder${NC}: ${RED}${THUNDER_PROJECT_NAME}${NC}\n"

        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME RBAC $RBAC_FILE ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME Jenkins $JENKINS_FILE ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Thunder build" $THUNDER_BUILD_FILE ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Thunder deployment" $THUNDER_DEPLOY_FILE ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Pipeline build and deploy" ${THUNDER_PIPELINE_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "MYSQL for Thunder" $MYSQL_DEPLOY_FILE ${3}

        #First Start Pipeline Build and Dyploy 
        oc start-build thunder-build-pipeline -n $JENKINS_PROJECT_NAME
        oc start-build thunder-deploy-pipeline -n $JENKINS_PROJECT_NAME

        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}The Jenkins wll be accessible via web address at:${NC}\n"
        printf "${LIGHT_GREAN}https://$(oc get route -n "${PROJECT_NAME_JENKINS}" | grep jenkins | awk '{print $2}')${NC}\n"
        printf "${RED}################${NC}\n"
        printf "${LIGHT_GREAN}The Thunder wll be accessible via web address at:${NC}\n"
        printf "${LIGHT_GREAN}$(oc get secret thunder-secret -o json -n thunder | grep site-user | tail -1 | awk '{match($0, /site-user/); print substr($0, RSTART - 0, RLENGTH + 16);}')${NC}\n"
        printf "${LIGHT_GREAN}$(oc get secret thunder-secret -o json -n thunder | grep site-password | tail -1 | awk '{match($0, /site-password/); print substr($0, RSTART - 0, RLENGTH + 23);}')${NC}\n"
        printf "${LIGHT_GREAN}https://$(oc get route -n ${PROJECT_NAME_THUNDER} | grep thunder-route | awk '{print $2}')${NC}\n"
    
    else
        PROCESS=Removing
        check_project_exist () {
        PROJECT=$1
            if [[ "$( oc get projects | grep $PROJECT | head -1 | awk '{print $1}' )" ]]
                then
                    PROJECT="$(oc get projects | grep $PROJECT | head -1 | awk '{print $1}')"
            fi
            echo $PROJECT
        }

        JENKINS_PROJECT_NAME=$(check_project_exist ${PROJECT_NAME_JENKINS})
        THUNDER_PROJECT_NAME=$(check_project_exist ${PROJECT_NAME_THUNDER})
        approve_yes_no_other ${LIGHT_GREAN} ${RED} ${NC} ${JENKINS_PROJECT_NAME} ${THUNDER_PROJECT_NAME} $1 $2
        printf "${LIGHT_GREAN}Project name for Jenkins${NC}: ${RED}${JENKINS_PROJECT_NAME}${NC}\n"
        printf "${LIGHT_GREAN}Project name for Thunder${NC}: ${RED}${THUNDER_PROJECT_NAME}${NC}\n"

        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME Jenkins ${JENKINS_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Thunder build" ${THUNDER_BUILD_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Thunder deployment" ${THUNDER_DEPLOY_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "Pipeline build and deploy" ${THUNDER_PIPELINE_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME "MYSQL for Thunder" ${MYSQL_DEPLOY_FILE} ${3}
        process_func ${RED} ${NC} ${LIGHT_GREAN} ${PROCESS} $JENKINS_PROJECT_NAME $THUNDER_PROJECT_NAME RBAC ${RBAC_FILE} ${3}
        oc delete identity anypassword:${OPENSHIFT_USER} > /dev/null 2>&1
fi

printf "${RED}################${NC}\n"
printf "${LIGHT_GREAN}The server is accessible via web console at:${NC}\n"
printf "${LIGHT_GREAN}https://${SERVER_IP}:8443/console${NC}\n"
printf "${RED}################${NC}\n"