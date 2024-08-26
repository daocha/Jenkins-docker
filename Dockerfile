# Use the official Jenkins image as the base image
FROM jenkins/jenkins:lts

# Switch to root user to install Node.js, system dependencies, and chromedriver
USER root

# Install Node.js v22.7.0 by downloading the binaries directly
RUN apt-get update && \
    apt-get install -y curl gnupg2 build-essential libssl-dev unzip && \
    NODE_VERSION=v22.7.0 && \
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

# Download and install Chromedriver
RUN CHROMEDRIVER_VERSION=128.0.6613.84 && \
    curl -fsSL https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip -o /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver-linux64/chromedriver && \
    ln -s /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Switch back to the Jenkins user
USER jenkins

# Configure npm to use a directory in the Jenkins home for global installations
RUN mkdir -p /var/jenkins_home/.npm-global && \
    npm config set prefix '/var/jenkins_home/.npm-global' && \
    echo 'export PATH=/var/jenkins_home/.npm-global/bin:$PATH' >> /var/jenkins_home/.profile

# Set the PATH to include the new npm global directory
ENV PATH=/var/jenkins_home/.npm-global/bin:$PATH
