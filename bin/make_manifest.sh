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

cat >bosh.yml <<EOF
---
name: bosh

resource_pools:
- name: default
  network: default
  cloud_properties:
    instance_type: m3.medium

jobs:
- name: bosh
  instances: 1
  persistent_disk: 32768
  templates:
  - {release: bosh, name: powerdns}
  - {release: bosh, name: nats}
  - {release: bosh, name: postgres}
  - {release: bosh, name: redis}
  - {release: bosh, name: director}
  - {release: bosh, name: blobstore}
  - {release: bosh, name: registry}
  - {release: bosh, name: health_monitor}
  networks:
  - name: vip
    static_ips: [$EIP]
  - name: default

  properties:
    postgres:
      user: postgres
      password: postges
      host: 127.0.0.1
      listen_address: 127.0.0.1
      database: bosh

    dns:
      address: $EIP
      db:
        user: postgres
        password: postges
        host: 127.0.0.1
        listen_address: 127.0.0.1
        database: bosh
      user: powerdns
      password: powerdns
      database:
        name: powerdns
      webserver:
        password: powerdns
      replication:
        basic_auth: replication:zxKDUBeCfKYXk
        user: replication
        password: powerdns
      recursor: $EIP

    nats:
      address: 127.0.0.1
      user: nats
      password: nats

    redis:
      address: 127.0.0.1
      password: redis

    director:
      name: bosh
      address: 127.0.0.1
      db:
        user: postgres
        password: postges
        host: 127.0.0.1
        listen_address: 127.0.0.1
        database: bosh

    blobstore:
      address: 127.0.0.1
      agent:
        user: agent
        password: agent
      director:
        user: director
        password: director

    registry:
      address: 127.0.0.1
      db:
        user: postgres
        password: postges
        host: 127.0.0.1
        listen_address: 127.0.0.1
        database: bosh
      http:
        user: registry
        password: registry

    hm:
      http:
        user: hm
        password: hm
      director_account:
        user: admin
        password: admin
      event_nats_enabled: false
      email_notifications: false
      tsdb_enabled: false
      pagerduty_enabled: false
      varz_enabled: true

    aws:
      access_key_id: $ACCESS_KEY_ID
      secret_access_key: $SECRET_ACCESS_KEY
      region: us-east-1
      default_key_name: $KEY_NAME
      default_security_groups: [$SECURITY_GROUP]

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
      region: us-east-1
      default_key_name: $KEY_NAME
      default_security_groups: [$SECURITY_GROUP]

    # Tells CPI how agent should listen for requests
    agent: {mbus: "https://nats:nats@0.0.0.0:6868"}

    registry: *registry

    blobstore:
      provider: local
      path: /var/vcap/micro_bosh/data/cache

    ntp: [0.north-america.pool.ntp.org]
EOF
