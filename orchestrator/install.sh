#!/bin/bash

createWrapper() {
  cat << 'EOF' > ${1}
#!/bin/bash
[[ -z "$(type -t docker-wrap)" ]] && . /etc/profile.d/wrapper-functions.sh
docker-wrap $@
EOF
  chmod +x ${1}
}

install() {
  local dest=`which docker`
  mv $dest ${dest}2
  createWrapper $dest
  echo "echo 'Welcome to Wingman!'" > "${ENV}"
  echo "export $(env -i sh -c env | tr '\n' ' ')" >> "${ENV}"
  chown $USER:$USER $ENV
}

# adding $user to sudoers
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER

DOCKER_GROUP="dockery"
#echo "$DOCKER_GROUP:$DOCKER_GID"
# if gid already exists, find the group name and add the user to the group
# if not create new group with gid and add user to the new group
cond=`getent group $DOCKER_GID | cut -d: -f1`
[[ -n "${cond}" ]] && DOCKER_GROUP=${cond}

echo "adding $DOCKER_GROUP to $USER"
[[ -z "${cond}" ]] && addgroup -g ${DOCKER_GID} ${DOCKER_GROUP}
addgroup ${USER} ${DOCKER_GROUP}

install