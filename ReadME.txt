#. Summary:  
Terraform script (main.tf) to automate the process of creating an AWS EC2 instance, along with this it will also install docker CE in EC2 machine and launch an NGINX container. 
Once the script is executed completely, NGINX web server can be accessed through elastic IP of Ec2 instance. Elastic IP will show up after running the terraform script.

#. To use the script - 
Terraform should be installed in the system. (This script is created on Terraform v1.3.7)
User needs to have AWS Access key ID and Secret access key and Region name available. User needs to pass these 3 parameters when prompted while running the script.

#. How to use?
Download Terraform (possibly v1.3.7)
Download the repository in your system available at https://github.com/Deependra-goswami/spark-assignment.git
open terminal
cd to the the directory "spart-assignment" and run below commands one by one. Please provide AWS keys and region when prompted.
terraform init
terraform plan       
terraform apply
After running these 3 commands Elastip IP will be generated and will appear on terminal. 
There is IP/port bridging between EC2 and Container so this elastic IP can be used as container IP.
Browse below link in any browser. Replace "elasticIP" with the actual IP address that we got as output after running terraform apply. 
http://elasticIP:80
This NGINX is getting served from the NGINX container running in EC2.

#Exercise Details 
1 - Done in terraform script
2 - Done in terrafrom script
3 - Done in terraform script
4 - Done in terraform script
5 - Can be done manually
6 - Done in terraform script
7 - Done in terraform script
8 - Need more clarity on what needs to be done in 8.B
9 - Done, 
10 - The Webserver is public facing, it can be made private by using reverse proxy/load-balancer. Cloud security services like WAF, AWS shield can be used to restrict and analyze potential threats. Remote access should be bounded to restricted IPs and should not be open to public. 
#Testing

===========

Please let me know in case of any issues/queries. Thanks. 



