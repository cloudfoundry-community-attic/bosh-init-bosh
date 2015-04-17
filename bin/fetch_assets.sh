#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR/..
mkdir -p assets
mkdir -p bin

if [[ ! -f assets/bosh-aws-cpi-release-5.tgz ]]; then
  echo "Downloading bosh-aws-cpi-release-5.tgz"
  curl -Lo releases/bosh-aws-cpi-release-5.tgz \
    "http://bosh.io/d/github.com/cloudfoundry-incubator/bosh-aws-cpi-release?v=5"
fi
if [[ ! -f assets/redis-9.tgz ]]; then
  echo "Downloading redis-9.tgz"
  curl -Lo assets/redis-9.tgz \
    "https://bosh.io/d/github.com/cloudfoundry-community/redis-boshrelease?v=9"
fi
if [[ ! -f assets/light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz ]]; then
  echo "Downloading light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz"
  curl -Lo assets/light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz \
    https://d26ekeud912fhb.cloudfront.net/bosh-stemcell/aws/bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz
fi
if [[ "$(which bosh-initx)X" == "X" ]]; then
  if [[ ! -f $DIR/../bin/bosh-init ]]; then
    echo "Downloading bosh-init"
    curl -o bin/bosh-init https://s3.amazonaws.com/concourse-tutorial-bosh-init/bosh-init
    chmod +x bin/bosh-init
  fi
fi
