![DevSecOps Architecture](images/Full_SDLC.png)

## Table of Contents

1. [System Overview](#system-overview)
2. [Prerequisites](#prerequisites)
3. [Initial Setup](#initial-setup)
4. [Docker Configuration](#docker-configuration)
5. [Jenkins Setup](#jenkins-setup)
6. [Security Scanning](#security-scanning)
7. [Pipeline Implementation](#pipeline-implementation)
8. [Deployment](#deployment)
9. [Maintenance](#maintenance)
10. [Troubleshooting](#troubleshooting)

---

## System Overview

### Network Architecture

- **Jenkins**: `172.20.0.2:8899`
- **SonarQube**: `172.20.0.3:9000`
- **Nginx**: `172.20.0.4:8080 (SSH:2222)`

---

## Prerequisites

### 1. System Requirements

```bash
# Install WSL (Windows) or use native Linux
wsl --install

# Install Docker
sudo apt update && sudo apt install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

### 2. .NET 6 SDK Installation

```bash
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --version 6.0.400
```

---

## Initial Setup

### Clone Repository

```bash
git clone https://github.com/tohxuewang99/DevSecOps
cd DevSecOps
```

### Start Containers

```bash
docker-compose up -d --build
```

---

## Docker Configuration

### `docker-compose.yml`

```yaml
version: '3'
services:
  jenkins:
    build:
      context: .
      dockerfile: jenkins.dockerfile
    ports: ["8899:8899"]
    volumes:
      - ./jenkins_home:/var/jenkins_home
    networks:
      MyCustomNetwork:
        ipv4_address: 172.20.0.2

  sonarqube:
    image: sonarqube:latest
    ports: ["9000:9000"]
    networks:
      MyCustomNetwork:
        ipv4_address: 172.20.0.3

  nginx:
    build:
      context: .
      dockerfile: nginx.dockerfile
    ports:
      - "8080:80"
      - "2222:22"
    networks:
      MyCustomNetwork:
        ipv4_address: 172.20.0.4

networks:
  MyCustomNetwork:
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

### `jenkins.dockerfile`

```dockerfile
FROM jenkins/jenkins:lts

USER root
RUN apt-get update && \
    apt-get install -y wget apt-transport-https openssh-client jq && \
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0 libicu-dev && \
    wget https://github.com/aquasecurity/trivy/releases/download/v0.45.0/trivy_0.45.0_Linux-64bit.deb && \
    dpkg -i trivy_0.45.0_Linux-64bit.deb

ENV JENKINS_OPTS="--httpPort=8899"
USER jenkins
EXPOSE 8899
```

### `nginx.dockerfile`

```dockerfile
FROM nginx:alpine

RUN apk add --no-cache bash wget icu-libs libgcc libstdc++ openssh && \
    wget https://dot.net/v1/dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --version 6.0.400 --install-dir /usr/share/dotnet && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN adduser -D -u 1000 admin_user && \
    echo "admin_user:verylongsecretpassword" | chpasswd

RUN sed -i 's/user nginx;/user admin_user;/g' /etc/nginx/nginx.conf

EXPOSE 80 22
CMD ["sh", "-c", "ssh-keygen -A && /usr/sbin/sshd -D & nginx -g 'daemon off;'"]
```

---

## Jenkins Setup

### Access Jenkins

Open your browser: [http://localhost:8899](http://localhost:8899)

### Install Required Plugins

- OWASP Dependency Check
- SonarQube Scanner
- SSH Agent
- Pipeline

### Configure Credentials

- Azure DevOps PAT
- SonarQube Token
- SSH Keys

---

## Security Scanning

- OWASP Dependency Check
- Trivy for container images

---

## Pipeline Implementation

### `Jenkinsfile`

```groovy
<Insert full Jenkinsfile here>
```

(Use the pipeline content you’ve already written in your full `Jenkinsfile`.)

---

## Deployment

### Linux Deployment Process

- SSH-based file transfer to Nginx container
- Non-root user execution
- Automatic process management

### Windows Deployment

- Manual deployment process
- Self-contained executable

---

## Maintenance

### Common Commands

```bash
# Stop all containers
docker-compose down

# View logs
docker-compose logs -f jenkins
docker-compose logs -f sonarqube

# Cleanup
docker system prune -a

# Access containers
docker exec -it jenkins bash
docker exec -it nginx sh
```

---

## Troubleshooting

### .NET SDK Not Found

```bash
docker exec -it jenkins bash
dotnet --list-sdks
./dotnet-install.sh --version 6.0.400
```

### SSH Connection Issues

```bash
ssh -v admin_user@localhost -p 2222
cat ~/.ssh/authorized_keys
```

### SonarQube Quality Gate Failing

- Check project quality gate configuration
- Verify metric thresholds
- Check analysis logs

### Jenkins Plugin Errors

- Update plugins
- Check compatibility matrix
- Review Jenkins logs

---

## Visual Reference

- Jenkins Pipeline View
- SonarQube Dashboard
- OWASP Report Sample