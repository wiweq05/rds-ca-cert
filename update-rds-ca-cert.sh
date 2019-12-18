#!/bin/bash
#################
#Author: Vivek Singh, Postgres Specialist Technical Account Manager, AWS
#V-1 : 12/13/2019
#################
clear

#creating list of all RDS instances in AWS account and region associated with AWS CLI.
#If you don't want to update ALL instances associated. Remove below describe-db-instances and list your instances in "instance-list.txt.

aws rds describe-db-instances |grep \"DBInstanceIdentifier\"|awk '{print $2}'|sed -e 's/"//g' > instance-list.txt
echo "instance-list.txt file is created. Getting current RDS cert details now."

#Getting list of current RDS Cert name ("rds-ca-2019") for each instance
while read p;
do aws rds describe-db-instances --db-instance-identifier "$p";
sleep 5; 
done <instance-list.txt | grep "CACertificateIdentifier"|awk '{print $2}'|sed -e 's/"//g'|sed -e 's/,//g' > before-update.txt

paste  instance-list.txt before-update.txt > before-rds-cert.txt

echo "before-rds-cert.txt file is created. Update starting in 10 sec ..."
sleep 10
echo "Update started. It may take a while depending on number of instances."

#updating each instance in above list to update RDS Cert with "rds-ca-2019"
while read p;
do aws rds modify-db-instance --db-instance-identifier "$p" --ca-certificate-identifier rds-ca-2019 --apply-immediately ;
echo "RDS instance "$p" updated"
sleep 5;
done <instance-list.txt >update-cert.log

sleep 60

#Getting list of updated RDS Cert name ("rds-ca-2019") for each instance
while read p;
do aws rds describe-db-instances --db-instance-identifier "$p";
sleep 5;
done <instance-list.txt | grep "CACertificateIdentifier"|awk '{print $2}'|sed -e 's/"//g'|sed -e 's/,//g' >after-update.txt

#creating a file with instance name and associated RDS Cert name
paste  instance-list.txt after-update.txt > final-rds-cert.txt
rm before-update.txt
rm after-update.txt

echo "Upgrade completed. final-rds-cert.txt file created."
