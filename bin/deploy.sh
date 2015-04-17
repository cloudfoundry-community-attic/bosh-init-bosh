#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

export PATH=$PATH:$PWD/bin

bosh-init deploy redis.yml \
  assets/light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz \
  assets/bosh-aws-cpi-release-5.tgz \
  assets/redis-9.tgz
