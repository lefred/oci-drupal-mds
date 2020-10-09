#!/bin/bash 


mysqlsh ${admin_username}:'${admin_password}'@${mds_ip} --sql -e "CREATE DATABASE ${drupal_schema};"
mysqlsh ${admin_username}:'${admin_password}'@${mds_ip} --sql -e "CREATE USER ${drupal_name} identified by '${drupal_password}';"
mysqlsh ${admin_username}:'${admin_password}'@${mds_ip} --sql -e "GRANT ALL PRIVILEGES ON ${drupal_schema}.* TO ${drupal_name};"

echo "Drupal Database and User created !"
