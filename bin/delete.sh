#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

export PATH=$PATH:$PWD/bin

bosh-init delete bosh.yml \
  assets/bosh-aws-cpi-release-5.tgz
