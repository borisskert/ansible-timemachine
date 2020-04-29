#!/bin/bash
set -e

# update-user-password.sh username password

user=$1
password=$2

is_user_existing() {
  if cat </etc/passwd | grep "^$user:" 1>/dev/null; then
    true
  else
    false
  fi
}

update_user_password() {
  echo "$user:$password" | chpasswd
}

if is_user_existing; then
  update_user_password
  echo "Password for $user updated"
fi
