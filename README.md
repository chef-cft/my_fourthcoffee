# my_fourthcoffee Cookbook

A Chef Automate demo cookbook for Windows 2012r2. This cookbook is meant to be used in conjunction with the BJC Chef Demo: https://github.com/chef-cft/bjc.  Estimated preparation time is around 30 minutes.

## Requirements

You should be able to spin up a BJC demo and log onto it, and clone this cookbook.  You'll also need AWS EC2 API keys which you can copy from your own ~/.aws/config or ~/.aws/credentials files.

## Instructions for Use

0.  Spin up 2.1.14 of aws-bjc-demo.  Log onto the workstation.  You can proceed with the below steps while the startup script is running.

1.  Create C:\Users\chef\\.aws\config and populate with your own settings.  You can copy these from your ~/.aws/config or ~/.aws/credentials file.  Your API keys are required to use the `knife ec2 server create` command.  Example:

```
[default]
region=us-west-2
aws_access_key_id=AKIAXXXXXXXXXXXXXXXXX
aws_secret_access_key=630SIMsn4Q0P5XXXXXXXXXXXXXXXXXXXXXXXXXX
```

2.  Configure C:\Users\chef\\.chef\knife.rb like below.  Note how the knife aws_credential_file is pointed at the config you created above.

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

3.  Fetch and run the powershell script onto your Workstation.  It will download the chef-client and my_fourthcoffee cookbooks and set up your environment to build Windows nodes running Fourth Coffee with SSL.

```
cd ~/
wget -OutFile windows_demo.ps1 https://raw.githubusercontent.com/scarolan/my_fourthcoffee/master/files/default/windows_demo.ps1
./windows_demo.ps1
```

4.  When the script is done it will spit out a file called knifeEc2Commands.txt onto your desktop.  You can copy the `knife ec2 server create` command in that file to spin up as many Windows instances as you want.  Just change the name WindowsServer1 to whatever you like.  Note that your machine will reboot itself a couple of times while it configures itself.  You can see all that in the Automate visibility console.  Expect reboots after WMF and Powershell5 are installed.  The machine should settle into steady 3 minute converges after about 10 minutes or so.  The first Chef run will look like it fails on installing WMF5.  This is normal.

5.  NOTE:  If you want to run test kitchen, you have to install Powershell5 manually on the instance.  Installation of Powershell over WinRM is not supported.  So you could `kitchen create`, log on and install powershell5 from here: https://msdn.microsoft.com/en-us/powershell/wmf/5.1/install-configure, *then* run `kitchen converge`.  You can fetch the windows admin password for your test instance from the .kitchen/default-osname.yml file that is created when you spin it up.

6.  Optional:  If you want to purge all data from Visibility, and have a 'Windows Only' demo, run this command on your automate server:

`curl -X DELETE http://localhost:9200/_all`
