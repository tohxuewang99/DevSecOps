FROM nginx:alpine

# Install dependencies for .NET 6 and required tools (bash, wget)
RUN apk add --no-cache bash wget icu-libs libgcc libstdc++ krb5-libs zlib openssh

# Install .NET 6 SDK (use a compatible version)
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --version 6.0.400 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Copy Nginx configuration files (optional)
COPY ./nginx/conf /etc/nginx

# Expose ports
EXPOSE 80 22

# Start SSH and Nginx
CMD sh -c "echo 'root:password' | chpasswd \
    && [ -f /etc/ssh/ssh_host_ecdsa_key ] || ssh-keygen -A \
    && /usr/sbin/sshd -D & \
    cd /usr/share/nginx/html/ \
    && nohup dotnet SimpleNetApp.dll > /dev/null 2>&1 & \
    nginx -g 'daemon off;'"