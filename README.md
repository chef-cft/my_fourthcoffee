# my_fourthcoffee Cookbook

A Chef Automate demo cookbook for Windows 2012r2. This cookbook is meant to be used in conjunction with the BJC Chef Demo: https://github.com/chef-cft/bjc

## Requirements

You should be able to spin up a BJC demo and log onto it, and clone this cookbook.  You'll also need AWS EC2 API keys which you can copy from your own ~/.aws/config or ~/.aws/credentials files.

## Instructions for Use

0.  Spin up 2.1.14 of aws-bjc-demo.  Log onto the workstation and wait for the startup script to complete before proceeding.

1.  Create C:\Users\chef\\.aws\config and populate with your own settings.  You can copy these from your ~/.aws/config or ~/.aws/credentials file.  Example:

```
[default]
region=us-west-2
aws_access_key_id=AKIAXXXXXXXXXXXXXXXXX
aws_secret_access_key=630SIMsn4Q0P5XXXXXXXXXXXXXXXXXXXXXXXXXX
```

2.  Configure C:\Users\chef\\.chef\knife.rb like so:

```
current_dir = File.dirname(__FILE__)
log_level            :info
log_location         STDOUT
node_name            'workstation-1'
chef_server_url      'https://chef.automate-demo.com/organizations/automate'
client_key           "#{ENV['HOME']}/.chef/private.pem"
trusted_certs_dir    "#{ENV['HOME']}/.chef/trusted_certs"
cookbook_path        "#{ENV['HOME']}/cookbooks"
data_collector.server_url 'https://automate.automate-demo.com/data-collector/v0/'
client_d_dir         'C:\Users\Default\.chef\config.d'
knife[:aws_credential_file] = "#{ENV['HOME']}/.aws/config"
```

3.  Run the below powershell script on your Workstation.  It will download cookbooks and set up your environment to build Windows nodes running Fourth Coffee with SSL.

https://github.com/scarolan/my_fourthcoffee/blob/master/files/default/windows_demo.ps1

4.  When the script is done it will spit out a file called knifeEc2Commands.txt onto your desktop.  You can copy the `knife ec2 server create` command in that file to spin up as many Windows instances as you want.  Just increment the node_name and tag to add more. 

5.  Optional:  Run 'kitchen converge' and 'kitchen verify'.  Demo the repair and revert recipes.  You may need to update .kitchen.yml with your own security_group_ids: setting.

6.  Optional:  If you want to purge all data from Visibility, and have a 'Windows Only' demo, run this command on your automate server:

`curl -X DELETE http://localhost:9200/_all`
