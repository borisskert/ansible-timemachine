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
* Template the initial netatalk config (including user and storage definition)
* Setup systemd unit file
* Start/Restart service

## Role parameters

### Main config

| Variable      | Type | Mandatory? | Default | Description           |
|---------------|------|------------|---------|-----------------------|
| alpine_version        | text | no | latest            | Your selected alpine version                       |
| netatalk_version      | text | no | latest            | Your selected netatalk version                     |
| image_name            | text | no | local/timemachine | Docker image name                                  |
| force_build           | boolean | no | no             | Forces to rebuild docker image                     |
| server_name           | text | no | Time Machine      | The name of the your time machine instance         |
| service_name          | text | no | timemachine       | The name of the systemd service                    |
| container_name        | text | no | timemachine.service | The name of the docker container                 |
| interface             | ip address | no | 0.0.0.0                 | Mapped network for web-interface ports |
| netatalk_port         | port       | no | <empty>                 | The default port (TCP) for netatalk is: 548 |
| host_name             | text       | no | <empty>                 | The showed hostname by netatalk             |
| config_volume         | path       | yes | <empty>                 | Path to config volume (which lays at /etc by default) |
| storage_volume        | path       | yes | <empty>                 | Path to where your backups will be stored                             |
| log_level             | text       | no  | info                    | Netatalk's configured log level (debug, info, ...)                    |
| mimic_model           | text       | no  | <empty>                 | Specifies the icon model that appears on clients                      |
| default_volume_size_limit | number     | no | 1000                | The default size limit for storage (1 GB in MiB)                       |
| users                     | array of User | no | []               | The users which will be registered to your timemachine                 |
| storages                  | array of Storage | no | []            | The storages for your users in your timemachine                        |

#### User definition

| Variable      | Type | Mandatory? | Default | Description           |
|---------------|------|------------|---------|-----------------------|
| username      | text | yes        |         | The username of your user (has to be unique!) |
| password      | text | yes        |         | The password of your user                     |
| uid           | number | yes      |         | The unix user id of your user (has to be unique!) |
| update_password | boolean | no    | no      | Update the user's password                        |

#### Storage definition

| Variable      | Type | Mandatory? | Default | Description           |
|---------------|------|------------|---------|-----------------------|
| name          | text | no         | Time Machine | The name of the users storage |
| path          | text | yes        |              | Where the storage will be located within the storages volume |
| user          | text | yes        |              | Whom this storage belongs to                                 |
| size_limit    | number | no       | value of `default_volume_size_limit` | The maximum size in MiB of this storage |

## Usage

### Requirements

```yaml
- name: install-timemachine
  src: https://github.com/borisskert/ansible-timemachine.git
  scm: git
```

### Playbook

```yaml
- hosts: test_machine
  become: yes

  roles:
    - role: install-timemachine
      alpine_version: '3.11'
      netatalk_version: '3.1'
      host_name: my-ansible-timemachine
      server_name: My Time Machine
      storage_volume: /srv/timemachine/storage
      config_volume: /srv/timemachine/config
      interface: 0.0.0.0
      netatalk_port: 548
      log_level: error
      mimic_model: RackMac
      users:
        - username: user1
          password: psw1
          uid: 2001
        - username: user2
          password: psw2
          uid: 2002
          update_password: yes
      storages:
        - name: Time Machine user1
          path: storage1
          user: user1
          size_limit: 256000
        - name: Time Machine user2
          path: storage2
          user: user2
          size_limit: 64000
```

## Testing

Requirements:

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Ansible](https://docs.ansible.com/)
* [Molecule](https://molecule.readthedocs.io/en/latest/index.html)
* [yamllint](https://yamllint.readthedocs.io/en/stable/#)
* [ansible-lint](https://docs.ansible.com/ansible-lint/)
* [Docker](https://docs.docker.com/)

### Run within docker

```shell script
molecule test
```

### Run within Vagrant

```shell script
 molecule test --scenario-name vagrant --parallel
```

I recommend to use [pyenv](https://github.com/pyenv/pyenv) for local testing.
Within the Github Actions pipeline I use [my own molecule Docker image](https://github.com/borisskert/docker-molecule).
