#!/bin/bash

# Add Enviroment to Progect "DRUSH_INSTALL=yes" to Install DRUSH
if [[ "${DRUSH_INSTALL}" == "yes" ]]
    then
        echo "Installing DRUSH"
        cd /usr/share/nginx/html/
        composer require drush/drush:master
    else
        echo "###"
        echo  Skip DRUSH installation. Enviroment "DRUSH_INSTALL" is  $DRUSH_INSTALL, must be "yes"
        echo "###"
fi

# Add Enviroment to Progect "PROMETHEUS_METRICS=yes" for Installing Prometheus Exporter
if [[ "${PROMETHEUS_METRICS_INSTALL}" == "yes" ]]
    then
        echo "Installing Prometheus Exporter"
        cd /usr/share/nginx/html/
        composer require 'drupal/prometheus_exporter:1.x-dev'
    else
        echo "###"
        echo  Skip Installing Prometheus Exporter. Enviroment "PROMETHEUS_METRICS_INSTALL" is  $PROMETHEUS_METRICS_INSTALL, must be "yes"
        echo "###"
fi

# Add Enviroment to Progect "SITE_INSTALL=yes" to Install Site by DRUSH
if [[ "${SITE_INSTALL}" == "yes" ]]
    then
        apk add mysql-client
        RESULT=`MYSQL_PWD="$MYSQL_PASSWORD" mysql -h $MYSQL_HOST -u $MYSQL_USER -D $MYSQL_DATABASE -e 'SHOW TABLES' | grep -o node | wc -l`
        apk del mysql-clientmc
        if [ $RESULT -lt 1 ]
            then
                echo "Install site by DRUSH"
                mv /usr/share/nginx/default.settings.php /usr/share/nginx/html/sites/default/default.settings.php
                cd /usr/share/nginx/html/
                vendor/bin/drush -y si \
                --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DATABASE} \
                --site-name=Thunder --account-name=${SITE_USER} --account-pass=${SITE_PASSWORD} --sites-subdir=default
                chown -R nginx:nginx /usr/share/nginx/html/sites/default
            else
                echo "###"
                echo  Skip Install . DataBase exist.
                echo "###"
        fi
    else
        echo "###"
        echo  Skip Install Site. Enviroment "SITE_INSTALL" is  $SITE_INSTALL, must be "yes"
        echo "###"
fi
# Add Enviroment to Progect "ENABLE_METRICS=yes" for enable Prometheus Exporter
if [[ "${ENABLE_METRICS}" == "yes" ]]
    then
        echo "Enable Prometheus Exporter"
        cd /usr/share/nginx/html/
        vendor/bin/drush en prometheus_exporter
        sleep 20
        vendor/bin/drush role-add-perm 'anonymous' 'access prometheus metrics'
  
    else
        echo "###"
        echo  Skip Installing Prometheus Exporter. Enviroment "ENABLE_METRICS" is  $ENABLE_METRICS, must be "yes"
        echo "###"
fi
