#!/bin/bash
set -e -u -o pipefail
source ~/.dotfiles/setup.lib.sh

cat <<EOF
# Autogenerated by ~/.dotfiles/ssh-config.sh

Host *
  AddKeysToAgent yes
  ChallengeResponseAuthentication no
  Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  Compression no
  ForwardAgent no
  ForwardX11 no
  HashKnownHosts no
  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
  MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
  Protocol 2
  RekeyLimit 64G 1h
  ServerAliveCountMax 6
  ServerAliveInterval 30
  TCPKeepAlive no
EOF

#if [[ $UID != 0 ]]; then
#  echo '  ControlMaster auto'
#  echo '  ControlPath ~/.ssh/socket/%r@%h:%p'
#  echo '  ControlPersist 300'
#  mkdir -p ~/.ssh/socket
#  chmod 0700 ~/.ssh ~/.ssh/socket
#fi

for name in id_ed25519 id_rsa; do
  if [[ -f ~/.ssh/$name ]]; then
    echo "  IdentityFile ~/.ssh/$name"
  fi
done

echo
for f in $(ls -A ~/.ssh | LC_ALL=C sort -V); do
  if [[ -d ~/.ssh/"$f" && -f ~/.ssh/"$f"/config ]]; then
    echo "Include ~/.ssh/$f/config"
  elif [[ "$f" == config.* ]]; then
    echo "Include ~/.ssh/$f"
  fi
done
