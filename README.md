# Ansible as a Docker Container

This project provides a configuration for running [ansible](https://www.ansible.com) in a docker container. It is provided so ansible can be run on a Windows host as there is no official download for Windows.


## License

MIT


## How To Use

The docker container built from contained configuration is exposed on Docker Hub as `cepharum/ansible`. Thus you can run ansible with

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible
```

This will pull the required image from Docker Hub and run a container with persistent volume named _ansible_ mounted at **/etc/ansible**.


## Using SSH Keys

You can generate your key file using

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible ssh-keygen
```

As a result this will print the content that must be stored on every remote system to be controlled via ansible.

The key files will saved as part of the volume named **ansible** here. 

> Ansible is run as a sub-process of ssh-agent. This keeps using keyphrase to protect your private key as convenient as possible.


## Configuring Hosts

You can edit the list of available hosts using

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible ssh-keygen
```

This is opening the related inventory file for edit. For a start you can add IP addresses or hostnames of remote systems line by line here.


## Ping the Hosts

After having stored the public key on every remote system entered before you should be able to ping those systems now:

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible all -m ping
```


## Ad-Hoc Commands

You can start running commands on all remote systems in parallel now:

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible all -a 'echo "Hello World!"'
```


## Using Ansible Tools

The docker container supports running `ansible` as well as any other particular tool that comes with ansible such as `ansible-playbook` or `ansible-vault`. Insert the desired script's name as first argument.

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible ansible-config dump
```


## Access Shell

Basically running shell on a container is pretty simple, but this container comes with an even simpler approach for starting a shell inside the container, e.g. for accessing the file in mounted volume:

```bash
docker run --rm -itv ansible:/etc/ansible cepharum/ansible shell
```
