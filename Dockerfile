# Use the official Jenkins image as the base image
FROM jenkins/jenkins:lts

# Switch to root user to install Node.js and system dependencies
USER root

# Install Node.js by downloading the binaries directly
RUN apt-get update && \
    apt-get install -y curl gnupg2 build-essential libssl-dev && \
    NODE_VERSION=v14.21.3 && \
    ARCH=x64 && \
    curl -fsSL https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-$ARCH.tar.xz | tar -xJf - -C /usr/local --strip-components=1 && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    apt-get install -y \
    libgtk2.0-0 \
    libgtk-3-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xauth \
    xvfb \
    dbus-x11 \
    libgbm-dev

# Switch to jenkins user to install Cypress globally
USER jenkins

# Configure npm to use a directory in the Jenkins home for global installations
RUN mkdir -p /var/jenkins_home/.npm-global && \
    npm config set prefix '/var/jenkins_home/.npm-global' && \
    echo 'export PATH=/var/jenkins_home/.npm-global/bin:$PATH' >> /var/jenkins_home/.profile

# Set the Cypress cache directory to avoid issues
ENV CYPRESS_CACHE_FOLDER=/var/jenkins_home/.cache/Cypress

# Set the PATH to include the new npm global directory
ENV PATH=/var/jenkins_home/.npm-global/bin:$PATH
