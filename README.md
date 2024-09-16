
Creating ec2 instance

#!/bin/bash 
sudo yum update -y 
sudo yum install -y java-1.8.0-openjdk -y 
sudo yum install -y tomcat tomcat-webapps tomcat-admin-webapps -y 
sudo systemctl start tomcat 
sudo systemctl enable tomcat

#If you are facing issues with permission while building
connect to VM and run below commands on VM
sudo chown ec2-user:ec2-user /var/lib/tomcat/webapps
sudo chmod 777 /var/lib/tomcat/webapps
