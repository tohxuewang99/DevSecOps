FROM jenkins/jenkins:lts

# Switch to the root user to install dependencies
USER root

# Install required updates and dependencies
RUN apt-get update && \
    apt-get install -y && \
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