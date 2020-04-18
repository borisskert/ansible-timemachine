# ansible-timemachine

Installs a timemachine server as docker container.

## System requirements

* Docker
* Systemd

## Role requirements

* python-docker package

## What does this role

* Template Dockerfile
* Build docker image
* Create volume paths for docker container
* Template the netatalk config
* Setup systemd unit file
* Start/Restart service

## Role parameters

### Main config

| Variable      | Type | Mandatory? | Default | Description           |
|---------------|------|------------|---------|-----------------------|
| image_name            | text | no | local/timemachine | Docker image name                                  |
| image_version         | text | no | latest            | Docker image version                               |
| force_build           | boolean | no | no             | Forces to rebuild docker image                     |
| service_name          | text | no | timemachine       | The name of the systemd service                    |
| container_name        | text | no | timemachine.service | The name of the docker container                 |
| interface             | ip address | no | 0.0.0.0                 | Mapped network for web-interface ports |
| netatalk_port         | port       | no | <empty>                 | THe default port (TCP) for netatalk is: 548 |
| config_volume         | path       | no | <empty>                 | Path to config volume (which lays at /etc by default) |
| data_volume           | path       | no | <empty>                 | Path to data and cache volume (which lays at /var/netatalk by default) |
| storage_volume        | path       | no | <empty>                 | Path to where your backups will be stored |
| log_level             | text       | no | info                    | Netatalk's configured log level (debug, info, ...) |
| timemachine_user      | user id    | no | 1001                    | Default timemachine user id |
| volume_size_limit     | number     | no | 262144000               | The maximum size of your backups folder (in Kb) |

## Usage

### Requirements

```yaml
- name: install-docker
  src: https://github.com/borisskert/ansible-timemachine.git
  scm: git
```

### Playbook

```yaml
- hosts: test_machine
  become: yes

  roles:
    - role: ansible-timemachine
      interface: 0.0.0.0
      netatalk_port: 548
      storage_volume: /srv/docker/timemachine/storage
      config_volume: /srv/docker/timemachine/config
      data_volume: /srv/docker/timemachine/data
      lock_volume: /srv/docker/timemachine/lock
      log_level: debug
```
