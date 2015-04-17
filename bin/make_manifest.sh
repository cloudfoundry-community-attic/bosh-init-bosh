#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR/..

if [[
"${EIP}X" == "X" ||
"${ACCESS_KEY_ID}X" == "X" ||
"${SECRET_ACCESS_KEY}X" == "X" ||
"${KEY_NAME}X" == "X" ||
"${PRIVATE_KEY_PATH}X" == "X" ||
"${SECURITY_GROUP}X" == "X" ]]; then
  echo "USAGE: EIP=xxx ACCESS_KEY_ID=xxx SECRET_ACCESS_KEY=xxx KEY_NAME=xxx PRIVATE_KEY_PATH=xxx SECURITY_GROUP=xxx ./bin/make_manifest.sh"
  exit 1
fi

cat >redis.yml <<EOF
---
name: redis

resource_pools:
- name: default
  network: default
  cloud_properties:
    instance_type: m3.medium

jobs:
- name: redis
  instances: 1
  templates:
  - {name: redis, release: redis}
  networks:
  - name: vip
    static_ips: [$EIP]
  - name: default

  properties:
    redis:
      address: "127.0.0.1"
      password: "redis"
      port: 6379

networks:
- name: default
  type: dynamic
- name: vip
  type: vip

cloud_provider:
  template: {name: cpi, release: bosh-aws-cpi}

  ssh_tunnel:
    host: $EIP
    port: 22
    user: vcap
    private_key: $PRIVATE_KEY_PATH

  registry: &registry
    username: admin
    password: admin
    port: 6901
    host: localhost

  # Tells bosh-micro how to contact remote agent
  mbus: https://nats:nats@$EIP:6868

  properties:
    aws:
      access_key_id: $ACCESS_KEY_ID
      secret_access_key: $SECRET_ACCESS_KEY
      default_key_name: $KEY_NAME
      default_security_groups: [$SECURITY_GROUP]
      region: us-east-1

    # Tells CPI how agent should listen for requests
    agent: {mbus: "https://nats:nats@0.0.0.0:6868"}

    registry: *registry

    blobstore:
      provider: local
      path: /var/vcap/micro_bosh/data/cache

    ntp: [0.north-america.pool.ntp.org]
EOF
