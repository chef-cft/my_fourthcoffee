#
# Cookbook Name:: my_fourthcoffee
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Set up a no-op reboot action
reboot 'ssl_updates_require_reboot' do
  action :nothing
  reason 'Need to reboot after updating SSL versions and ciphers.'
end

# Get a modern version of Powershell
# No longer required for Windows Server 2016
# include_recipe 'powershell::powershell5'

# Install the base fourthcoffee site
include_recipe 'fourthcoffee'

# Poke a hole in the firewall for our new https website
windows_firewall_rule 'https' do
  localport '443'
  protocol 'TCP'
  firewall_action :allow
end

# Create our SSL certificate
cookbook_file 'C:\Users\Administrator\Desktop\fourthcoffee.pfx' do
  source 'fourthcoffee.pfx'
  action :create
end

# Install our SSL certificate
windows_certificate 'C:\Users\Administrator\Desktop\fourthcoffee.pfx' do
  pfx_password 'password'
end

# Bind our certficate to port 443
windows_certificate_binding 'WIN-SDH3PTM46Q7' do
  port 443
  action :create
end

# Remove telnet because it's 2017
#windows_feature ['TelnetServer', 'TelnetClient'] do
#  action :remove
#end

# Telnet is not even included on 2016 server
# dsc_resource 'Remove Telnet Server' do
#   resource :windowsfeature
#   property :ensure, 'Absent'
#   property :name, 'Telnet-Server'
# end
# 
# dsc_resource 'Remove Telnet Client' do
#   resource :windowsfeature
#   property :ensure, 'Absent'
#   property :name, 'Telnet-Client'
# end

# Create a new iis_pool and application with SSL enabled.
iis_pool 'myapp' do
  runtime_version "4.0"
  action :add
end

# We are using the same content directory for http and https
iis_site 'MySite' do
  protocol :https
  port 443
  path node['fourthcoffee']['install_path']
  application_pool 'myapp'
  action [:add,:start]
end

############################################################
# Just uncomment one or more of the below resources to remediate.
# If any of these registry keys change a reboot will be triggered.
############################################################

# # Disable SSL V3
# registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\SSL 3.0\Client' do
#   values [{:name => 'DisabledByDefault', :type => :dword, :data => '1'}]
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
#   recursive true
#   action :create
# end

# registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\SSL 3.0\Server' do
#   values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
#   recursive true
#   action :create
# end

# # Disable TLS 1.0 and 1.1
# registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\TLS 1.0\Server' do
#   values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
#   recursive true
#   action :create
# end

# registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\TLS 1.1\Server' do
#   values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
#   recursive true
#   action :create
# end

# # Disable RC4 ciphers
# ['RC2 128/128', 'RC2 56/128', 'RC2 40/128', 'RC4 128/128', 'RC4 64/128', 'RC4 56/128', 'RC4 40/128'].each do |cipher|
#   registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\#{cipher}" do
#     values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#     recursive true
#     action :create
#     notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
#   end
# end

# registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\DES 56/56" do
#   values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#   recursive true
#   action :create
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
# end

# registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\Triple DES 168/168" do
#   values [{:name => 'Enabled', :type => :dword, :data => '0'}]
#   recursive true
#   action :create
#   notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
# end
