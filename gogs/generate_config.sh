#!/bin/bash -x

cd "$(dirname "$0")"

ssh-keygen -t rsa -f config/ssh_host_rsa_key
ssh-keygen -t ed25519 -f config/ssh_host_ed25519_key
