#!/bin/bash

# Variables
TOMCAT_WEBAPPS_DIR="/var/lib/tomcat/webapps"
ARTIFACT_BUCKET="my-maven-build-artifacts"
ARTIFACT_NAME="myapp.war"
EC2_USER="ec2-user"
EC2_HOST="ec2-54-175-52-123.compute-1.amazonaws.com"  # Replace with your EC2 instance's public DNS or IP
PEM_KEY="/tmp/key.pem"  # Path to the fetched PEM file

# Step 1: Download the artifact (WAR file) from S3
echo "Downloading artifact from S3..."
aws s3 cp s3://$ARTIFACT_BUCKET/$ARTIFACT_NAME /tmp/$ARTIFACT_NAME

# Step 2: Copy the WAR file to the Tomcat webapps directory on the EC2 instance
echo "Copying the WAR file to EC2 instance..."
scp -i $PEM_KEY -o StrictHostKeyChecking=no /tmp/$ARTIFACT_NAME $EC2_USER@$EC2_HOST:$TOMCAT_WEBAPPS_DIR

echo "Deployment completed."
