#!/bin/bash

bosh_version=${bosh_version:-155}
aws_cpi_version=${aws_cpi_version:-5}
stemcell_version=${stemcell_version:-2830}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR/..
mkdir -p assets
mkdir -p bin

if [[ ! -f assets/bosh-${bosh_version}.tgz ]]; then
  echo "Downloading bosh-${bosh_version}.tgz"
  curl -Lo assets/bosh-${bosh_version}.tgz \
    "https://bosh.io/d/github.com/cloudfoundry/bosh?v=${bosh_version}"
fi
if [[ ! -f assets/bosh-aws-cpi-release-${aws_cpi_version}.tgz ]]; then
  echo "Downloading bosh-aws-cpi-release-${aws_cpi_version}.tgz"
  curl -Lo assets/bosh-aws-cpi-release-${aws_cpi_version}.tgz \
    "http://bosh.io/d/github.com/cloudfoundry-incubator/bosh-aws-cpi-release?v=${aws_cpi_version}"
fi
if [[ ! -f assets/light-bosh-stemcell-${stemcell_version}-aws-xen-ubuntu-trusty-go_agent.tgz ]]; then
  echo "Downloading light-bosh-stemcell-${stemcell_version}-aws-xen-ubuntu-trusty-go_agent.tgz"
  curl -Lo assets/light-bosh-stemcell-${stemcell_version}-aws-xen-ubuntu-trusty-go_agent.tgz \
    https://d26ekeud912fhb.cloudfront.net/bosh-stemcell/aws/bosh-stemcell-${stemcell_version}-aws-xen-ubuntu-trusty-go_agent.tgz
fi
if [[ "$(which bosh-init)X" == "X" ]]; then
  if [[ ! -f $DIR/../bin/bosh-init ]]; then
    echo "Downloading bosh-init"
    os_name=$(uname -s)
    if [ "$os_name" == "Linux" ]; then
      curl -Lo bin/bosh-init https://s3.amazonaws.com/concourse-tutorial-bosh-init/bosh-init-linux64
    else
      curl -Lo bin/bosh-init https://s3.amazonaws.com/concourse-tutorial-bosh-init/bosh-init-darwin
    fi
    chmod +x bin/bosh-init
  fi
fi
