if [ "$2" == "j" ]
    then
        oc process -f create_project.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
        oc process -f jenkins/jenkins_persistent.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
        oc rollout status dc/jenkins -n jenkins-ci

fi
if [ "$1" == "apply" ]
    then
        oc process -f create_project.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
        # oc adm policy add-scc-to-user anyuid -z default -n thunder
        # oc adm policy add-scc-to-group anyuid system:authenticated
        # oc adm policy add-scc-to-user anyuid -z deployer -n thunder
fi

oc process -f thunder/thunder_build.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
oc process -f thunder/thunder_pipeline.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
oc process -f thunder/thunder_mysql.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
oc rollout status dc/mysql -n thunder
oc process -f thunder/thunder_deploy.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
oc adm pod-network join-projects --to=thunder jenkins-ci

if [ "$1" == "delete" ]
    then
        if [ "$2" == "j" ]
            then
                oc process -f jenkins/jenkins_persistent.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
                oc process -f create_project.yaml -p JENKINS_PROJECT_NAME=jenkins-ci -p THUNDER_PROJECT_NAME=thunder | oc $1 -f -
        fi
        # oc adm policy remove-scc-from-user anyuid -z default -n thunder
        # oc adm policy remove-scc-from-user anyuid -z deployer -n thunder
        # oc adm policy remove-scc-from-group anyuid system:authenticated -n thunder
        oc delete project thunder

fi