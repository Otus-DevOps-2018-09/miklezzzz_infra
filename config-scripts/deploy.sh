#!/bin/bash

#Simple script for deploying our awesome app 

cd ~ && git clone -b monolith https://github.com/express42/reddit.git && cd reddit && bundle install && puma -d

