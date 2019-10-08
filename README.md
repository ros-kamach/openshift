![alt text](https://i1.wp.com/blog.openshift.com/wp-content/uploads/redhatopenshift.png?w=1376&ssl=1)
# Implimitation Jenkins and Thunder CMS for OpenShift

This repository contains components for running Build and manual deploy Thunder CMS by pipeline (Jenkinsfile) for your OpenShift cluster. Repo 
<img src="https://www.drupal.org/files/Thunder_WBM_20160126.png" alt="Thunder" width="10%"/> **"[ubuntu_build](https://github.com/ros-kamach/thunder_nginx_phpfpm.git)"**

To deploy, run:

syntax:
```
$ bash <*.sh> <project name for monitoring> <apply or delete> 
```
example:
```
$ bash prometheus-grafana.sh openshift-metrics apply
```
