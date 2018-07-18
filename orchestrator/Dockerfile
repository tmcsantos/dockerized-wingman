FROM tmcsantos/java:8-jdk-alpine

MAINTAINER Tiago Santos <tsantos84@gmail.com>

ARG user=buildguy
ARG group=buildguy
ARG uid=1000
ARG ugrp=1000

ENV USER=$user
ENV ENV="/home/$user/.profile"
ENV WINGMAN_HOME="/home/$user/wingman"

ARG GIT_USER_NAME="Your Name"
ARG GIT_USER_EMAIL="you@example.com"

ADD wingman.tar /home/$user/
COPY install.sh /usr/local/bin/

# wingman is run with user `buildguy`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
#RUN addgroup -g ${ugrp} ${group} && \
#    adduser -S -u ${uid} -G ${group} -s /bin/bash -D ${user}

# Install Docker
RUN apk --no-cache add --update bash docker git perl sudo shadow curl && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh && \
    bash -c "uid=${uid} ugrp=${ugrp} install.sh" && \
    mkdir -p ${WINGMAN_HOME}/source && \
    chown -R ${user}:${group} ${WINGMAN_HOME}

COPY docker-entrypoint.sh /usr/local/bin/
COPY post-install.sh /usr/local/bin/
COPY wrapper-functions.sh /etc/profile.d/

USER ${user}

RUN git config --global user.name "${GIT_USER_NAME}" && \
    git config --global user.email "${GIT_USER_EMAIL}"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash", "-lc", "$WINGMAN_HOME/bin/karaf server"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8181/cxf/orchestrator?_wadl&_type=xml || exit 1

# expose orchestrator port
EXPOSE 8181
