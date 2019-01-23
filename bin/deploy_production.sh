#!/bin/sh

scp docker-compose.prod.yml zalupaka:/home/gryphon/docker-compose.prod.yml
scp config/traefik/traefik.toml zalupaka:/home/gryphon/traefik.toml
# scp -r config/ssl zalupaka:/home/gryphon/ssl

ssh zalupaka "sudo docker stack deploy -c /home/gryphon/docker-compose.prod.yml zalupaka --with-registry-auth"
