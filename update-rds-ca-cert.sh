#!/bin/bash
#################
#Author: Vivek Singh, Database Specialist- Postgres, AWS
#V-1 : 12/13/2019
#################
clear
#creating list of all RDS instances in AWS account and region associated with AWS CLI
aws rds describe-db-instances |grep \"DBInstanceIdentifier\"|awk '{print $2}'|sed -e 's/"//g' > instance-list.txt

#updating each instance in above list to update RDS Cert with "rds-ca-2019"
while read p; do   aws rds modify-db-instance --db-instance-identifier "$p" --ca-certificate-identifier rds-ca-2019 --apply-immediately ;   sleep 10;  done <instance-list.txt
sleep 90

#Getting list of updated RDS Cert name ("rds-ca-2019") for each instance
while read p; do aws rds describe-db-instances --db-instance-identifier "$p";  sleep 5; done <instance-list.txt | grep "CACertificateIdentifier"|awk '{print $2}'|sed -e 's/"//g'|sed -e 's/,//g' >after-update-txt

#creating a file with instance name and associated RDS Cert name
paste  instance-list.txt after-update-txt > final-rds-cert.txt
clear
