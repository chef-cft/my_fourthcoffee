# Script to generate knife ec2 server create commands

function Get-Subnet {
  $mac = Get-Mac
  Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/network/interfaces/macs/$mac/subnet-id
}

function Get-SecurityGroup {
  $mac = Get-Mac
  Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/network/interfaces/macs/$mac/security-group-ids
}

function Write-ec2Commands {
    Write-Host "Updating $args[0]"

    $subnet = Get-Subnet
    $sg = Get-SecurityGroup

    New-Item $args[0] -type file -value "knife ec2 server create -x Administrator -P Opscode123 --node-name WindowsServer1 --identity-file C:\Users\chef\.ssh\id_rsa --ssh-key chef_demo_2x --region us-west-2 -g $sg --subnet $subnet -I ami-2ad04f4a --flavor m3.large --tags Name='WindowsServer1' --json-attribute-file attributes.json --associate-public-ip --user-data user_data --run-list recipe['chef-client::config'],recipe['chef-client::task'],recipe['my_fourthcoffee'],recipe['audit']" -force
}

cd ${env:userprofile}\cookbooks
git clone https://github.com/chef-cookbooks/chef-client
cd chef-client
berks install; berks upload
cd ${env:userprofile}\cookbooks
git clone https://github.com/scarolan/my_fourthcoffee
cd my_fourthcoffee
berks install; berks upload
Write-ec2Commands ${env:userprofile}\Desktop\knifeEc2Commands.txt
