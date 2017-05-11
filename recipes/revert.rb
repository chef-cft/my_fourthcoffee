#
# Cookbook Name:: my_fourthcoffee
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

############################################################
# Use this recipe to revert your Webserver to its previous 
# state. It will re-enable SSLv3, TLS 1.0, and TLS 1.1
############################################################

# Set up a no-op reboot action
reboot 'ssl_updates_require_reboot' do
  action :nothing
  reason 'Need to reboot after updating SSL versions and ciphers.'
end

# Re-enable SSL V3
registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\SSL 3.0\Client' do
  values [{:name => 'DisabledByDefault', :type => :dword, :data => '0'}]
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
  recursive true
  action :create
end

registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\SSL 3.0\Server' do
  values [{:name => 'Enabled', :type => :dword, :data => '1'}]
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
  recursive true
  action :create
end

# Re-enable TLS 1.0 and 1.1
registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\TLS 1.0\Server' do
  values [{:name => 'Enabled', :type => :dword, :data => '1'}]
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
  recursive true
  action :create
end

registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\TLS 1.1\Server' do
  values [{:name => 'Enabled', :type => :dword, :data => '1'}]
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
  recursive true
  action :create
end

# Disable RC4 ciphers
['RC2 128/128', 'RC2 56/128', 'RC2 40/128', 'RC4 128/128', 'RC4 64/128', 'RC4 56/128', 'RC4 40/128'].each do |cipher|
  registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\#{cipher}" do
    values [{:name => 'Enabled', :type => :dword, :data => '1'}]
    recursive true
    action :create
    notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
  end
end

registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\DES 56/56" do
  values [{:name => 'Enabled', :type => :dword, :data => '1'}]
  recursive true
  action :create
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
end

registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\Schannel\\Ciphers\\Triple DES 168/168" do
  values [{:name => 'Enabled', :type => :dword, :data => '1'}]
  recursive true
  action :create
  notifies :reboot_now, 'reboot[ssl_updates_require_reboot]', :delayed
end