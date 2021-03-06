name             'my_fourthcoffee'
maintainer       'Chef Software'
maintainer_email 'saleseng@chef.io'
license          'All rights reserved'
description      'Installs/Configures my_fourthcoffee'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.4'

depends 'windows'
depends 'iis'
depends 'windows_firewall'
depends 'fourthcoffee'
depends 'push-jobs'
depends 'audit'
depends 'powershell'
