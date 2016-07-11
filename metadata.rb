name              'rundeck'
maintainer        'Ron Bogdanoff'
maintainer_email  'you@example.com'
license           'apachev2'
description       'Installs/Configures rundeck'
long_description  'Installs/Configures rundeck'
version           '0.1.0'

%w( debian ).each do |os|
  supports os
end

depends           'java', '~> 1.40'
issues_url        'https://github.com/rbogdanoff/rundeck-cookbook/issues'
source_url        'https://github.com/rbogdanoff/rundeck-cookbook'
