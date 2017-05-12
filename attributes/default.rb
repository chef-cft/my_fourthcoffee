# We are storing *all* our default attributes here to keep things simple.
# In the real world you would move all of this stuff into a Chef role.

# Push jobs 2.2.0 on windows appears to be broken so we are pinning to 2.1.4
default['push_jobs']['package_url'] = "https://packages.chef.io/files/stable/push-jobs-client/2.1.4/windows/2012r2/push-jobs-client-2.1.4-1-x86.msi"
default['push_jobs']['package_checksum'] = "3b979f8d362738c8ac126ace0e80122a4cbc53425d5f8cf9653cdd79eca16d62"
default['push_jobs']['allow_unencrypted'] = true

# Get your audit on
default['audit']['reporter'] = 'chef-automate'
default['audit']['profiles'] = [
  {
    name: 'admin/ssl-benchmark',
    url: 'https://github.com/dev-sec/ssl-baseline/archive/v1.1.1.tar.gz'
  }
]

# Ship audit data to chef automate
default['chef_client']['config']['data_collector.server_url'] = "https://automate.automate-demo.com/data-collector/v0/"
default['chef_client']['config']['data_collector.token'] = "93a49a4f2482c64126f7b6015e6b0f30284287ee4054ff8807fb63d9cbd1c506"
