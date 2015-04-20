#!/bin/bash

bosh_version=${bosh_version:-155}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

export PATH=$PWD/bin:$PATH

bosh-init deploy bosh.yml \
  assets/light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz \
  assets/bosh-aws-cpi-release-5.tgz \
  assets/bosh-${bosh_version}.tgz
