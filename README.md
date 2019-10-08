![alt text](https://i1.wp.com/blog.openshift.com/wp-content/uploads/redhatopenshift.png?w=1376&ssl=1)
# Implimitation Jenkins and Thunder CMS for OpenShift

This repository contains components for running Build and manual deploy Thunder CMS by pipeline (Jenkinsfile) for your OpenShift cluster. 

Build runs from preconfigurated components in 
<img src="https://www.drupal.org/files/Thunder_WBM_20160126.png" alt="Thunder" width="10%"/> **"[alpine_build](https://github.com/ros-kamach/thunder_nginx_phpfpm/tree/alpine_build)"**

To deploy, run:

syntax:
```
$ bash <*.sh> <project name for monitoring> <apply or delete> 
```
example:
```
$ bash prometheus-grafana.sh openshift-metrics apply
```
