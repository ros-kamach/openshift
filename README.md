![alt text](https://i1.wp.com/blog.openshift.com/wp-content/uploads/redhatopenshift.png?w=1376&ssl=1)
![alt text](https://www.drupal.org/files/Thunder_WBM_20160126.png)
# Implimitation Jenkins and Thunder CMS for OpenShift

This repository contains components for running Build and manual deploy Thunder CMS by pipeline (Jenkinsfile) for your OpenShift cluster. Repo <img src="https://cdn.freebiesupply.com/logos/large/2x/ubuntu-4-logo-png-transparent.png" alt="Thunder" width="4%"/> **"[ubuntu_build](https://github.com/ros-kamach/thunder_nginx_phpfpm/tree/ubuntu_build)"**

To deploy, run:

syntax:
```
$ bash <*.sh> <project name for monitoring> <apply or delete> 
```
example:
```
$ bash prometheus-grafana.sh openshift-metrics apply
```
