LOGIN=system:admin
SERVER_IP=$(minishift ip)


oc login -u $LOGIN > /dev/null
echo "################"
echo Logged as $LOGIN
echo "################"

oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/rbac.yaml | oc $1 -f -
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/jenkins/jenkins_persistent.yaml  | oc $1 -f -
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_build.yaml  | oc $1 -f -
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_deploy.yaml  | oc $1 -f -
oc process -f https://raw.githubusercontent.com/ros-kamach/openshift/master/thunder/thunder_mysql.yaml  | oc $1 -f -

echo "################"
echo "The server is accessible via web console at:"
echo "https://${SERVER_IP}:8443/console"
echo "################"