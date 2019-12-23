# rds-ca-cert
Automate updating RDS CA Certificate
1. This script updates the CA Cert ("rds-ca-2019") for ALL RDS instances in given account and Region. 
2. Copy the update-rds-ca-cert.sh shell script on a Linux EC2 instance with CLI configured.
3. Make script executable: chmod +x update-rds-ca-cert.sh
4. Run the file:  
[ec2-user@ip-pgrpt]$ ./update-rds-ca-cert.sh | tee update-rds-ca-cert.log
5. Input the AWS Region you want to run this script: 
AWS Region (e.g. us-west-2):
5. Running this file creates below three files:
- instance-list.txt : This is the list of ALL RDS instances not configured with rds-ca-2019 cert in the mentioned region .
(If you don't want to update all instances in the account/region, update this list with names of the instance you wish to update at once.)
- update-cert.log : RDS modify raw log.


**Please Note**
1. Updating RDS CA Cert reboots the instance. For quick reboot stop all connections to the database instance.
2. The best practice is to update the application side CA Cert first if its validating server certificate.
3. Test the script in test environment thoroughly.
4. Before updating the production environment, update the staging, QA, and test environment first. 
