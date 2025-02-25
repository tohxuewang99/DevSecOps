FROM jenkins/jenkins:lts

# Switch to the root user to install dependencies
USER root

# Install required updates and dependencies
RUN apt-get update && \
    apt-get install -y wget apt-transport-https && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0 libicu-dev && \
    apt-get install -y jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the Jenkins environment variables
ENV JENKINS_OPTS="--httpPort=8899"

# Set Jenkins user back for security
USER jenkins

# Expose the desired port
EXPOSE 8899

# Start Jenkins
CMD ["jenkins.sh"]

# docker build -t jenkins .
# docker run -p 8899:8899 -v ./jenkins_container:/var/jenkins_home --name jenkins -d jenkins
# docker system prune --all