#!/bin/sh

docker-compose -f docker-compose.test.local.yml up -d
docker-compose -f docker-compose.test.local.yml exec sut bin/wait-for.sh db:3306 -- rake db:setup

