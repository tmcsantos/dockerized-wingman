# https://github.com/jenkinsci/docker/blob/master/README.md
FROM jenkins/jenkins:lts-alpine
MAINTAINER Tiago Santos <tsantos84@gmail.com>

USER root
#RUN apk --no-cache add --update python
#USER jenkins

COPY plugins.txt plugins.txt
RUN /usr/local/bin/install-plugins.sh < plugins.txt && \
    echo 2.60.2 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    echo 2.60.2 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion
USER jenkins