#!/bin/sh

docker-compose -f docker-compose.test.local.yml exec sut rspec $1
