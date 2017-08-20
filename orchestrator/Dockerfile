FROM tmcsantos/java:8-jdk-alpine

MAINTAINER Tiago Santos <tsantos84@gmail.com>

ARG user=buildguy
ARG group=buildguy
ARG uid=1000
ARG did=0

# wingman is run with user `buildguy`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN addgroup -g ${uid} ${group} && \
    adduser -S -u ${uid} -G ${group} -s /bin/bash -D ${user}

ENV USER=$user
ENV ENV="/home/$user/.profile"
ENV WINGMAN_HOME="/home/$user/wingman"

ARG GIT_USER_NAME="Your Name"
ARG GIT_USER_EMAIL="you@example.com"

ADD wingman.tar /home/$user/
COPY install.sh /usr/local/bin/

# Install Docker
RUN apk --no-cache add --update bash docker git perl sudo shadow && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh && \
    chown -R ${user}:${group} ${WINGMAN_HOME} && \
    export DOCKER_GID=${did} && \
    bash -c "install.sh"

COPY docker-entrypoint.sh /usr/local/bin/
COPY wrapper-functions.sh /etc/profile.d/

USER ${user}

RUN git config --global user.name "${GIT_USER_NAME}" && \
    git config --global user.email "${GIT_USER_EMAIL}"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash", "-lc", "$WINGMAN_HOME/bin/karaf server"]

# expose orchestrator port
EXPOSE 8181