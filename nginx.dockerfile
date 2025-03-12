FROM nginx:alpine

# Install dependencies for .NET 6 and required tools
RUN apk add --no-cache bash wget icu-libs libgcc libstdc++ krb5-libs zlib openssh

# Install .NET 6 SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --version 6.0.400 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Create a non-root user
RUN adduser -D -u 1000 admin_user

# Set a password for admin_user
RUN echo "admin_user:verylongsecretpassword" | chpasswd

# Expose ports
EXPOSE 80 22

# Ensure Nginx runs as admin_user
RUN sed -i 's/user nginx;/user admin_user;/g' /etc/nginx/nginx.conf

# Start SSH and Nginx
CMD sh -c "chmod -R 755 /usr/share/nginx/html/ \
    && chown -R admin_user:admin_user /usr/share/nginx/html/ \
    && chown -R admin_user:admin_user /home/admin_user/.ssh \
    && chmod 700 /home/admin_user/.ssh \
    && chmod 600 /home/admin_user/.ssh/authorized_keys \
    && ssh-keygen -A \
    && /usr/sbin/sshd -D & \
    cd /usr/share/nginx/html/ \
    && nohup dotnet SimpleNetApp.dll > /dev/null 2>&1 & \
    nginx -g 'daemon off;'"
