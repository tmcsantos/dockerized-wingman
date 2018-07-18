#!/bin/bash

create_wrapper() {
  cat << 'EOF' > ${1}
#!/bin/bash
[[ -z "$(type -t docker-wrap)" ]] && . /etc/profile.d/wrapper-functions.sh
docker-wrap $@
EOF
  chmod +x ${1}
}

install_wrapper() {
  local dest=`which docker`
  mv $dest ${dest}2
  create_wrapper $dest
  echo "echo 'Welcome to Wingman!'" > "${ENV}"
  echo "export $(env -i sh -c env | tr '\n' ' ')" >> "${ENV}"
  chown $USER:$USER $ENV
}

# create user
GROUPNAME="buildguy"
# if gid already exists, find the group name and add the user to the group
# if not create new group with gid and add user to the new group
cond=`getent group ${ugrp} | cut -d: -f1`
echo "creating ${USER}:${GROUPNAME}"

addgroup -g ${uid} ${GROUPNAME}
adduser -S -u ${uid} -G ${GROUPNAME} -s /bin/bash -D ${USER}
[[ -n "${cond}" ]] && addgroup ${USER} ${cond}
addgroup ${USER} root


# adding $user to sudoers
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER

install_wrapper