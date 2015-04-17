bosh-init deploy redis
======================

```
./bin/fetch_assets.sh
```

```
bosh-init deploy redis.yml assets/light-bosh-stemcell-2830-aws-xen-ubuntu-trusty-go_agent.tgz assets/bosh-aws-cpi-release-5.tgz assets/redis-9.tgz
```

```
Deployment manifest: '/Users/drnic/Projects/bosh-deployments/experiments/redis-micro/redis-from-scratch.yml'
Deployment state: 'deployment.json'

Started validating
  Validating stemcell... Finished (00:00:00)
  Validating releases... Finished (00:00:00)
  Validating deployment manifest... Finished (00:00:00)
  Validating cpi release... Finished (00:00:00)
Finished validating (00:00:00)

Started installing CPI
  Compiling package 'ruby_aws_cpi/052a28b8976e6d9ad14d3eaec6d3dd237973d800'... Finished (00:01:22)
  Compiling package 'bosh_aws_cpi/deabbf731a4fedc9285324d85af6456cfa74c10c'... Finished (00:00:34)
  Rendering job templates... Finished (00:00:00)
  Installing packages... Finished (00:00:03)
  Installing job 'cpi'... Finished (00:00:00)
Finished installing CPI (00:02:01)

Starting registry... Finished (00:00:00)
Uploading stemcell 'bosh-aws-xen-ubuntu-trusty-go_agent/2830'... Finished (00:00:09)

Started deploying
  Creating VM for instance 'redis/0' from stemcell 'ami-94c187fc light'... Finished (00:00:47)
  Waiting for the agent on VM 'i-3d7ffec0' to be ready... Finished (00:01:17)
  Rendering job templates... Finished (00:00:09)
  Compiling package 'redis-server/b53d5357ab95a74c9489cd98a024e6ef6047aba0'... Finished (00:03:36)
  Updating instance 'redis/0'... Finished (00:00:06)
  Waiting for instance 'redis/0' to be running... Finished (00:00:00)
Finished deploying (00:05:58)
```
