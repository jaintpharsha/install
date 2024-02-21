#!/bin/bash 
echo "STEP1: Update the ubuntu && install - 'unzip' and 'jdk-17' " 
sudo apt update -y && sudo apt install -y unzip openjdk-17-jdk

echo
echo "STEP2: Download maven3.9.6.zip and unzip it" 
wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip && unzip apache-maven-3.9.6-bin.zip

echo
echo "STEP3: Create a symbolic link of mvn binary in $PATH (Load the mvn command)" 
sudo ln -s /home/ubuntu/apache-maven-3.9.6/bin/mvn /usr/local/sbin/mvn
sudo chmod 777 /usr/local/sbin/mvn

echo
echo "_______________ jdk and maven installed _______________" 
