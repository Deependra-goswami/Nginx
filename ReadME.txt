#. Summary:  
Terraform script (main.tf) to automate the process of creating an AWS EC2 instance, along with this it will also install docker CE in EC2 machine and launch an NGINX container. 
Once the script is executed completely, NGINX web server can be accessed through elastic IP of Ec2 instance. Elastic IP will show up after running the terraform script.

#. To use the script - 
Terraform should be installed in the system. (This script is created on Terraform v1.3.7)
User needs to have AWS Access key ID and Secret access key and Region name available. User needs to pass these 3 parameters when prompted while running the script.

#. How to use?
Download Terraform (possibly v1.3.7)
Download the repository in your system fr



