bosh-init deploy bosh
=====================

The new [bosh-init](https://github.com/cloudfoundry/bosh-init) CLI can do more than just deploy Micro BOSH.

But in this project that's exactly what we'll do - deploy a Micro BOSH using the new `bosh-init` CLI.

This project will deploy a single server/VM/instance on AWS EC2 us-east-1 region running BOSH.

It's a fully featured BOSH. Fit for all your BOSH needs.

Usage
-----

First, fetch the required assets, including the `bosh-init` CLI:

```
./bin/fetch_assets.sh
```

Then create the `bosh.yml` manifest:

```
EIP=23.23.23.23 \
ACCESS_KEY_ID=xxx SECRET_ACCESS_KEY=xxx \
KEY_NAME=xxx PRIVATE_KEY_PATH=xxx \
SECURITY_GROUP=xxx \
./bin/make_manifest.sh
```

Finally, run the `bosh-init deploy` command (via helpful wrapper):

```
./bin/deploy.sh
```

The output will look similar to:

```
Deployment manifest: '/Users/drnic/Projects/bosh-deployments/experiments/bosh-init-bosh/bosh.yml'
Deployment state: 'deployment.json'

Started validating
  Validating stemcell... Finished (00:00:00)
  Validating releases... Finished (00:00:00)
  Validating deployment manifest... Finished (00:00:00)
  Validating cpi release... Finished (00:00:00)
Finished validating (00:00:00)

Started installing CPI
  Compiling package 'ruby_aws_cpi/052a28b8976e6d9ad14d3eaec6d3dd237973d800'... Finished (00:00:00)
  Compiling package 'bosh_aws_cpi/deabbf731a4fedc9285324d85af6456cfa74c10c'... Finished (00:00:00)
  Rendering job templates... Finished (00:00:00)
  Installing packages... Finished (00:00:04)
  Installing job 'cpi'... Finished (00:00:00)
Finished installing CPI (00:00:05)

Starting registry... Finished (00:00:02)
Uploading stemcell 'bosh-aws-xen-ubuntu-trusty-go_agent/2830'... Skipped [Stemcell already uploaded] (00:00:00)

Started deploying
  Waiting for the agent on VM 'i-de3a3a09'... Finished (00:00:00)
  Stopping jobs on instance 'unknown/0'... Finished (00:00:00)
  Deleting VM 'i-de3a3a09'... Finished (00:00:50)
  Creating VM for instance 'bosh/0' from stemcell 'ami-94c187fc light'... Finished (00:01:09)
  Waiting for the agent on VM 'i-8e838359' to be ready... Finished (00:01:57)
  Rendering job templates... Finished (00:00:05)
  Compiling package 'nginx/0ccc40df032599285cb16a4f2dfdf324a4a61a26'... Finished (00:02:00)
  Compiling package 'libpq/f181aa97dd63567e04d897762f0440fb2bef1517'... Finished (00:01:13)
  Compiling package 'mysql/e5309aed88f5cc662bc77988a31874461f7c4fb8'... Finished (00:00:52)
  Compiling package 'powerdns/e41baf8e236b5fed52ba3c33cf646e4b2e0d5a4e'... Finished (00:00:24)
  Compiling package 'ruby/c28e01e561dd7e1bd4ce44f134970dc9f5d7e8fc'... Finished (00:05:33)
  Compiling package 'postgres/aa7f5b110e8b368eeb8f5dd032e1cab66d8614ce'... Finished (00:00:53)
  Compiling package 'redis/1700dbaacfd8780da866e404bd41b46fb4be5c2f'... Finished (00:01:19)
  Compiling package 'genisoimage/008d332ba1471bccf9d9aeb64c258fdd4bf76201'... Finished (00:00:55)
  Compiling package 'registry/28fb5b8fa6f12c990048c5fa212366920a261b17'... Finished (00:01:22)
  Compiling package 'nats/6a31c7bb0d5ffa2a9f43c7fd7193193438e20e92'... Finished (00:00:25)
  Compiling package 'health_monitor/85e246cbdafb1aadaf6972c6defefe28e2e10a28'... Finished (00:00:54)
  Compiling package 'director/56cd5b874af720289964eee18057f80f90da5091'... Finished (00:02:01)
  Updating instance 'bosh/0'... Finished (00:00:18)
  Waiting for instance 'bosh/0' to be running... Finished (00:00:33)
Finished deploying (00:23:11)
```

Using BOSH
----------

To install the Ruby/Bundler based `bosh` CLI:

```
bundle install
```

Now target your new BOSH server:

```
bosh target 23.23.23.23 bosh-init-bosh
```

The default user/pass is `admin` / `admin`.

Destroy BOSH
------------

To delete your BOSH server:

```
./bin/delete.sh
```

The output will look like:

```
Deployment manifest: '/Users/drnic/Projects/bosh-deployments/experiments/bosh-init-bosh/bosh.yml'
Deployment state: 'deployment.json'

Started validating
  Validating releases... Finished (00:00:00)
  Validating deployment manifest... Finished (00:00:00)
  Validating cpi release... Finished (00:00:00)
Finished validating (00:00:00)

Started installing CPI
  Compiling package 'ruby_aws_cpi/052a28b8976e6d9ad14d3eaec6d3dd237973d800'... Finished (00:00:00)
  Compiling package 'bosh_aws_cpi/deabbf731a4fedc9285324d85af6456cfa74c10c'... Finished (00:00:00)
  Rendering job templates... Finished (00:00:00)
  Installing packages... Finished (00:00:04)
  Installing job 'cpi'... Finished (00:00:00)
Finished installing CPI (00:00:04)

Starting registry... Finished (00:00:00)

Started deleting deployment
  Waiting for the agent on VM 'i-8e838359'... Finished (00:00:00)
  Stopping jobs on instance 'unknown/0'... Finished (00:00:00)
  Deleting VM 'i-8e838359'... Finished (00:00:43)
  Deleting stemcell 'ami-94c187fc light'... Finished (00:00:09)
Finished deleting deployment (00:01:04)
```

Security Group
--------------

The security group must open the following ports to the machine running `./bin/deploy.sh` or `bosh-init deploy`:

-	22
-	6868

The security group must open the following port for the `bosh` CLI client:

-	25555

Dependencies
------------

On Ubuntu, the following packages are required in order for the `bosh-aws-cpi` to compile Ruby successfully:

```
sudo apt-get install -y build-essential zlibc zlib1g-dev \
  openssl libxslt-dev libxml2-dev libssl-dev \
  libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3
```

I don't know what the matching requirements are for OS X anymore. That would require buying a new Mac. Wait... let me ask my wife.
