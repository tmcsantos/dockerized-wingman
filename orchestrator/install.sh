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

# adding $user to sudoers
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER

install_wrapper