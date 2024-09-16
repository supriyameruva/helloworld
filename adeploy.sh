#!/bin/bash
# deploy.sh

# Variables
TOMCAT_WEBAPPS_DIR="/path/to/tomcat/webapps"
ARTIFACT_BUCKET="your-s3-bucket"
ARTIFACT_NAME="sample-app-${CODEBUILD_BUILD_NUMBER}.war"
EC2_USER="ec2-user"
EC2_HOST="your-ec2-public-dns"
PEM_KEY="path/to/your/key.pem"

# Download the artifact from S3
aws s3 cp s3://$ARTIFACT_BUCKET/$ARTIFACT_NAME /tmp/$ARTIFACT_NAME

# Copy the WAR file to the Tomcat webapps directory
scp -i $PEM_KEY /tmp/$ARTIFACT_NAME $EC2_USER@$EC2_HOST:$TOMCAT_WEBAPPS_DIR

# Restart Tomcat (you can use a systemctl or init.d command depending on how Tomcat is configured)
ssh -i $PEM_KEY $EC2_USER@$EC2_HOST << 'EOF'
sudo systemctl restart tomcat
EOF
