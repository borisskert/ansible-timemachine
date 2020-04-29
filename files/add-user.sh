#!/bin/bash
set -e

# add-user.sh user_id username password home

user_id=$1
user=$2
password=$3
home=$4
gid=$user_id
group=$user

is_group_existing() {
  if cat </etc/group | grep "^$group:" 1>/dev/null; then
    true
  else
    false
  fi
}

is_user_existing() {
  if cat </etc/passwd | grep "^$user:" 1>/dev/null; then
    true
  else
    false
  fi
}

create_group() {
  addgroup -g "$gid" "$group"
}

create_user() {
  adduser -u "$user_id" -S -H -h "$home" -G "$group" "$user"
  echo "$user:$password" | chpasswd
}

if ! is_group_existing; then
  create_group
  echo "Group $group created"
fi

if ! is_user_existing; then
  create_user
  echo "User $user created"
fi
