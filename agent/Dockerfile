FROM tmcsantos/java:8-jdk-alpine

# Install "stuff" and cleanup. Why do we need all this btw?
RUN apk --no-cache add --update bash git sudo curl wget \
    nodejs nodejs-npm libaio tar bzip2 unzip zip

# Set environment
ENV ANT_HOME=/usr/lib/ant/current \
    MAVEN_HOME=/usr/lib/maven/current \
    PATH=${PATH}:/usr/lib/ant/current/bin:/usr/lib/maven/current/bin

# install Ant
ENV ANT_VERSION=1.9.8
RUN mkdir -p /usr/lib/ant && \
    wget -q https://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -zxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /usr/lib/ant && \
    ln -s /usr/lib/ant/apache-ant-${ANT_VERSION} ${ANT_HOME} && \
    rm apache-ant-${ANT_VERSION}-bin.tar.gz

# install Maven
ENV MAVEN_VERSION=3.3.9
RUN mkdir -p /usr/lib/maven && \
    wget -q https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/lib/maven && \
    ln -s /usr/lib/maven/apache-maven-${MAVEN_VERSION} ${MAVEN_HOME} && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Add buildguy user
ARG UID
RUN addgroup -g ${UID} buildguy && \
    adduser -S -u ${UID} -G buildguy -s /bin/bash -D buildguy
# project work directory
RUN mkdir /home/buildguy/project

ADD docker-agent-fat-0.0.1.jar /home/buildguy/docker-agent.jar
ADD settings.xml /home/buildguy/.m2/settings.xml

# Make buildguy own his home
RUN chown -R buildguy:buildguy /home/buildguy/

# Run as buildguy from here on
USER buildguy

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]