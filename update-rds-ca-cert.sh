#!/bin/bash
#################
#Author: Vivek Singh, Postgres Specialist Technical Account Manager, AWS
#V-1 : 12/13/2019
#################
clear
#Step 1: List all AWS Regions
aws ec2 describe-regions | grep  "RegionName" | sed -e 's/"RegionName": "//g'| sed -e 's/"//g' > region.txt
echo -e "Region.txt file is created. Now checking RDS instances with NOT rds-ca-2019 cert in these regions."

#Step 2: List of ALL RDS instances with  CA Cert not as rds-ca-2019
while read p; 
do aws rds describe-db-instances --query 'DBInstances[?CACertificateIdentifier != `rds-ca-2019`].DBInstanceIdentifier' --output text --region $p; 
done <region.txt | xargs -n 1 > instance_list.txt
echo -e "instance_list files is created. Total `< instance_list.txt wc -l` instances need to be updated. Now updating these RDS instances with rds-ca-2019 cert."

#Step 3: Update CA Cert to rds-ca-2019
while read p;
do aws rds modify-db-instance --db-instance-identifier "$p" --ca-certificate-identifier rds-ca-2019 --apply-immediately ;
echo "RDS instance "$p" updated";
done <instance_list.txt >update-cert.log
echo -e "CA Cert update is completed."

