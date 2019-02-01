#!/bin/sh

ansible-playbook config/playbook/production.yml -i config/playbook/hosts --tags=deploy
