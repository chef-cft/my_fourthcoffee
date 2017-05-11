# my_fourthcoffee Cookbook

A Chef Automate demo cookbook for Windows 2012r2. This cookbook is meant to be used in conjunction with the BJC Chef Demo: https://github.com/chef-cft/bjc

## Requirements

You should be able to spin up a BJC demo and log onto it, and clone this cookbook.  You'll also need AWS EC2 API keys which you can copy from your own ~/.aws/config or ~/.aws/credentials files.

## Instructions for Use

0.  Spin up 2.1.14 of aws-bjc-demo.  Install the knife-ec2 gem:
  `chef gem install knife-ec2`

1.  Create C:\Users\chef\.aws\config and populate with your own settings.  You can copy these from your ~/.aws/config or ~/.aws/credentials file.  Example:

```
[default]
region=us-west-2
aws_access_key_id=AKIAXXXXXXXXXXXXXXXXX
aws_secret_access_key=630SIMsn4Q0P5XXXXXXXXXXXXXXXXXXXXXXXXXX
```

2.  Configure C:\Users\chef\.chef\knife.rb like so:

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

3.  Clone the my_fourthcoffee cookbook into your cookbooks directory:

```
cd ~/cookbooks
git clone https://github.com/scarolan/my_fourthcoffee
cd my_fourthcoffee
berks install; berks upload
```

4.  Do the same for the chef-client cookbook

```
cd ~/cookbooks
git clone https://github.com/chef-cookbooks/chef-client
cd chef-client
berks install; berks upload
```

4.  Crank up one or more Windows instances.  You can fetch the security group and subnet from the .kitchen.local.yml file located in the Test_Kitchen folder on the desktop.  You should run this command from the main directory of the my_fourthcoffee cookbook.  Just increment the --node-name and --tags parameters for each new machine:

```
knife ec2 server create -x Administrator -P Opscode123 --node-name WindowsServer1 --identity-file C:\Users\chef\.ssh\id_rsa --ssh-key chef_demo_2x --region us-west-2 -g sg-aff696d4 --subnet subnet-31f9016a -I ami-2ad04f4a --flavor m3.large --tags Name="WindowsServer1" --json-attribute-file attributes.json --associate-public-ip --user-data user_data --run-list "recipe['chef-client::config'],recipe['chef-client::task'],recipe['my_fourthcoffee'],recipe['audit']"
```

5.  Optional:  Run 'kitchen converge' and 'kitchen verify'.  Demo the repair and revert recipes.  You may need to update .kitchen.yml with your own security_group_ids: setting.