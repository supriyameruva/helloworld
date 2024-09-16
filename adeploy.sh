#!/bin/bash
# deploy.sh

# Variables
TOMCAT_WEBAPPS_DIR="/var/lib/tomcat/webapps"
ARTIFACT_BUCKET="my-maven-build-artifacts"
ARTIFACT_NAME="myapp-${CODEBUILD_BUILD_NUMBER}.war"
EC2_USER="ec2-user"
EC2_HOST="ec2-54-175-52-123.compute-1.amazonaws.com"
PEM_KEY="path/to/your/key.pem"

# Download the artifact from S3
aws s3 cp s3://$ARTIFACT_BUCKET/$ARTIFACT_NAME /tmp/$ARTIFACT_NAME

# Copy the WAR file to the Tomcat webapps directory
scp -i $PEM_KEY /tmp/$ARTIFACT_NAME $EC2_USER@$EC2_HOST:$TOMCAT_WEBAPPS_DIR

# Restart Tomcat (you can use a systemctl or init.d command depending on how Tomcat is configured)
ssh -i $PEM_KEY $EC2_USER@$EC2_HOST << 'EOF'
sudo systemctl restart tomcat
EOF
