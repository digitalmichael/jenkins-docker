FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER root

RUN apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
apt-get update && \
apt-get -y install docker-ce 

RUN apt-get install -y docker-ce

RUN echo "jenkins    ALL=(ALL:ALL)    NOPASSWD: ALL" >> etc/sudoers

RUN usermod -a -G docker jenkins

# COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY insecure.groovy /usr/share/jenkins/ref/init.groovy.d/insecure.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins

# copy seedjob
COPY seed-jobs/laradock-nginx.xml /usr/share/jenkins/ref/jobs/laradock-nginx/config.xml


