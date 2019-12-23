#!/bin/bash
#################
#Author: Vivek Singh, Postgres Specialist Technical Account Manager, AWS
#V-1 : 12/13/2019
#################
clear
echo -n -e  "AWS Region (e.g. us-west-2): "
read REGION
echo "$REGION" > region.txt

#Step 1: List of ALL RDS instances with  CA Cert not as rds-ca-2019 in given region
echo -e "Checking RDS instances with NOT rds-ca-2019 cert in $REGION region."
while read p; do aws rds describe-db-instances --query 'DBInstances[?CACertificateIdentifier != `rds-ca-2019`].DBInstanceIdentifier' --output text --region $p; done <region.txt | xargs -n 1 > instance_list.txt
sed -i '/^$/d' instance_list.txt
echo -e "instance_list files is created. Total `< instance_list.txt wc -l` instances need to be updated."

#Step 2: Update CA Cert
if [[ $(wc -l <"instance_list.txt") -eq 0 ]];then
echo -e "All RDS instances are already with cert rds-ca-2019."
exit 1

else
echo "Now updaing `< instance_list.txt wc -l` RDS instances with rds-ca-2019 cert."
        while read p;
        do aws rds modify-db-instance --db-instance-identifier "$p" --ca-certificate-identifier rds-ca-2019 --apply-immediately ;
        echo "RDS instance "$p" updated";
        done <instance_list.txt >update-cert.log
        echo -e "CA Cert update is completed. Total `grep -r "RDS instance" update-cert.log | wc -l` instances are updated."
fi
