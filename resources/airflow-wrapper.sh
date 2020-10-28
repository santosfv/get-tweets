#!/bin/bash
set -e

DATABASE_NAME="airflow"

function initDB(){
	if [[ ! -z "`mysql -h mysql -u root -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$DATABASE_NAME'" 2>&1`" ]];
	then
		echo "Database $DATABASE_NAME exists"
	else
		echo "Creating database $DATABASE_NAME"
		mysql -u root -e "CREATE DATABASE $DATABASE_NAME"
		airflow initdb
	fi
}

initDB
exec airflow $*
