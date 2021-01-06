# ansible-timemachine

Installs a timemachine server as docker container.

## System requirements

* Docker
* Systemd

## Role requirements

* (none so far)

## What does this role

* Template Dockerfile
* Create volume paths for docker container
* Template the initial netatalk config (including user and storage definition)
* Setup systemd unit file
* Start/Restart service

## Role parameters

### Main config

| Variable      | Type | Mandatory? | Default | Description           |
|---------------|------|------------|---------|-----------------------|
| timemachine_alpine_version        | text | no | latest            | Your selected alpine version                       |
| timemachine_netatalk_version      | text | no | latest            | Your selected netatalk version                     |
| timemachine_image_name            | text | no | local/timemachine | Docker image name                                  |
| timemachine_force_build           | boolean | no | no             | Forces to rebuild docker image                     |
| timemachine_service_name          | text | no | timemachine       | The name of the systemd service                    |
| timemachine_container_name        | text | no | timemachine.service | The name of the docker container                 |
| timemachine_interface             | ip address | no | 0.0.0.0                 | Mapped network for web-interface ports |
| timemachine_netatalk_port         | port       | no | <empty>                 | The default port (TCP) for netatalk is: 548 |
| timemachine_host_name             | text       | no | <empty>                 | The showed hostname by netatalk             |
| timemachine_config_volume         | path       | yes | <empty>                 | Path to config volume (which lays at /etc by default) |
| timemachine_storage_volume        | path       | yes | <empty>                 | Path to where your backups will be stored                             |
| timemachine_log_level             | text       | no  | info                    | Netatalk's configured log level (debug, info, ...)                    |
| timemachine_mimic_model           | text       | no  | <empty>                 | Specifies the icon model that appears on clients                      |
| timemachine_default_volume_size_limit | number     | no | 1000                | The default size limit for storage (1 GB in MiB)                       |
| timemachine_users                     | array of User | no | []               | The users which will be registered to your timemachine                 |
| timemachine_storages                  | array of Storage | no | []            | The storages for your users in your timemachine                        |

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
| size_limit    | number | no       | value of `timemachine_default_volume_size_limit` | The maximum size in MiB of this storage |

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
      timemachine_alpine_version: '3.11'
      timemachine_netatalk_version: '3.1'
      timemachine_host_name: my-ansible-timemachine
      timemachine_storage_volume: /srv/timemachine/storage
      timemachine_config_volume: /srv/timemachine/config
      timemachine_interface: 0.0.0.0
      timemachine_netatalk_port: 548
      timemachine_log_level: error
      timemachine_mimic_model: RackMac
      timemachine_users:
        - username: user1
          password: psw1
          uid: 2001
        - username: user2
          password: psw2
          uid: 2002
          update_password: yes
      timemachine_storages:
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
* [libvirt](https://libvirt.org/)
* [Ansible](https://docs.ansible.com/)
* [Molecule](https://molecule.readthedocs.io/en/latest/index.html)
* [yamllint](https://yamllint.readthedocs.io/en/stable/#)
* [ansible-lint](https://docs.ansible.com/ansible-lint/)
* [Docker](https://docs.docker.com/)

### Run within docker

```shell script
molecule test
molecule test --scenario-name all-parameters
```

### Run within Vagrant

```shell script
 molecule test --scenario-name vagrant --parallel
 molecule test --scenario-name vagrant-all-parameters --parallel
```

I recommend to use [pyenv](https://github.com/pyenv/pyenv) for local testing.
Within the Github Actions pipeline I use [my own molecule Docker image](https://github.com/borisskert/docker-molecule).
