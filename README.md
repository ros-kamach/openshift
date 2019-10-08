![alt text](https://i1.wp.com/blog.openshift.com/wp-content/uploads/redhatopenshift.png?w=1376&ssl=1)
# Implimitation Jenkins and Thunder CMS for OpenShift

This repository contains components for running Build and manual deploy Thunder CMS by pipeline (Jenkinsfile) for your OpenShift cluster. 

Build runs from preconfigurated components in 
<img src="https://www.drupal.org/files/Thunder_WBM_20160126.png" alt="Thunder" width="20%"/> **"[alpine_build](https://github.com/ros-kamach/thunder_nginx_phpfpm/tree/alpine_build)"**

To Impliment Monitoring use repository
<img src="https://logodix.com/logo/1736712.png" alt="Thunder" width="20%"/> **"[openshift_monitoring](https://github.com/ros-kamach/openshift_monitoring.git)"**

To deploy, run:

syntax:
```
$ bash <*.sh> <jenkins_project> <thunder_proje> <apply or delete>
```
example:
```
$ bash project.sh jenkins-ci thunder apply
```
