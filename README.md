# DevSecOps
# Azure DevOps and GitHub for DevSecOps

# Steps to create a simple Net 6.0 Project:
# Step 1: Set Up Your Environment
Download and install the .NET 6 SDK from the official .NET website.
Download and install Visual Studio Code from the official website.
Search for "C#" and install the official extension provided by Microsoft.

# Step 2:
Create a simple Net Application using the terminal with: 
dotnet new mvc -n SimpleNetApp

# Add a controller in Controllers folder name it Controller.cs

# To build and run:
Cd SimpleNetApp
dotnet build
dotnet run

# Step 3:
# Back to home folder and create a testing project for unit testing:
cd ..
dotnet new xunit -n SimpleNetApp.Tests

# Add the reference into the testing project
cd SimpleNetApp.Tests
dotnet add reference ../SimpleMvcApp/SimpleMvcApp.csproj

# Add a Controller for a simple Unit Testing class ControllerTests.cs

# To test:
cd SimpleNetApp.Tests
dotnet test

# Steps to make a CICD with jenkins using a dockerfile:
# Step 1:
Download and install WSL from the official website

# Install Docker using the WSL following the below script:
#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install Docker dependencies
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker’s repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list
sudo apt update

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker service
sudo service docker start

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Configure Docker to start automatically in WSL
echo "sudo service docker start" >> ~/.bashrc

# Verify Docker installation
docker --version

echo "Docker installation completed successfully!"

# Step 2:
# Create a dockerfile to contain Jenkins lts version

# Install updates and dependencies:
RUN apt-get update && apt-get install -y

# Build the Docker image
docker build -t jenkins .

# Run the Jenkins Container
docker run -p 8899:8899 -v ./jenkins_container:/var/jenkins_home --name jenkins -d jenkins

# Create a pipeline to start the CICD for checkout to retrieve the files from a private repository
# Step 1: 
# Create a pipeline of any name and check the box the 2 boxes:
![check boxes](Images/image.png)

# For GitHub, create a generate a API token following access rights for a private repository project:
![GitHubAccessToken](Images/image-1.png)

# For AzureDevOps, create a generate a PAT/API token following access rights for a private repository project:
![AzureAccessToken](Images/image-2.png)

# Add the credentials in Jenkins with the created token following:
![Add credentials](Images/image-3.png)

# Step 2:
# Install Plugin Pipeline: Stage View:
![Pipeline stage view plugin](Images/image-4.png)

# Update jenkinsfile and try building the pipeline

# Update jenkinsfile by adding new steps to run Unit Testing for reliability testing

# Failed to build and run unit testing, jenkins .net SDK does not support .net 6.0 contrary to the documentation, more infomation on
# https://medium.com/@nestor.panu/building-an-asp-net-6-application-on-docker-based-jenkins-d6c8aaf94756
# https://github.com/dotnet/core/issues/6172

# Update dockerfile to install .net 6.0 sdk during build

# Step 3:
# Install Plugin OWASP Depedency Check for Software Composition Analysis (SCA):
![OWASP Dependency Check Plugin](Images/image-5.png)

# Add tools to install the latest OWASP Depedency Check directly from github:
![Add into tools to install and use latest](Images/image-6.png)

# Update jenkinsfile to test the OWASP dependency check step
