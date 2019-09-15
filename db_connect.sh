#!/bin/bash
# Add Enviroment to Progect "CONNECT_TO_DB=yes" to apply script

if [[ "${CONNECT_TO_DB}" == "yes" ]]
    then
        mv /usr/share/nginx/settings.php /usr/share/nginx/html/sites/default/
        sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php/7.2/php.ini
        sed -i "s|MYSQL_DATABASE|'database' => '${MYSQL_DATABASE}',|i" /usr/share/nginx/html/sites/default/settings.php
        sed -i "s|MYSQL_USER|'username' => '${MYSQL_USER}',|i" /usr/share/nginx/html/sites/default/settings.php
        sed -i "s|MYSQL_PASSWORD|'password' => '${MYSQL_PASSWORD}',|i" /usr/share/nginx/html/sites/default/settings.php
        sed -i "s|MYSQL_PORT|'host' => '${MYSQL_PORT}',|i" /usr/share/nginx/html/sites/default/settings.php
        sed -i "s|MYSQL_HOST|'port' => '${MYSQL_HOST}',|i" /usr/share/nginx/html/sites/default/settings.php
        tail -n 9  /usr/share/nginx/html/sites/default/settings.php
    else
        echo "###"
        echo  Skip connection to Data_Base. Enviroment "CONNECT_TO_DB" is  $CONNECT_TO_DB, must be "yes"
        rm -f settings.php
        echo "###"
fi

if [[ "${DRUSH_INSTALL}" == "yes" ]]
    then
        cd /usr/share/nginx/html/
        composer require drush/drush:master
    else
        echo "###"
        echo  Skip DRUSH installation. Enviroment "DRUSH_INSTALL" is  $DRUSH_INSTALL, must be "yes"
        echo "###"
fi

echo PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT}
echo MYSQL_DATABASE=${MYSQL_DATABASE}
echo MYSQL_USER=${MYSQL_USER}
echo MYSQL_PASSWORD=${MYSQL_PASSWORD}
echo MYSQL_PORT=${MYSQL_PORT}
echo MYSQL_HOST=${MYSQL_HOST}