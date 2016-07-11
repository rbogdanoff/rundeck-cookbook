#
# Cookbook Name:: rundeck
# Attributes:: default
#
# Copyright 2016 Ron Bogdanoff
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default['rundeck']['user']             = 'rundeck'
default['rundeck']['group']            = 'rundeck'
default['rundeck']['config_dir']       = '/etc/rundeck/'

default['rundeck']['http_port']        = '4440'
default['rundeck']['https_port']       = '4443'
default['rundeck']['hostname']         = 'localhost'
default['rundeck']['log_level']        = 'INFO'
default['rundeck']['jvm_runtime_opts'] = '-Xmx1024m -Xms256m -XX:MaxPermSize=256m'

case node['platform_family']
when 'debian'
  default['rundeck']['version']        = '2.6.8-1-GA'
  default['rundeck']['downloadpath']   = 'http://dl.bintray.com/rundeck/rundeck-deb/'
  default['rundeck']['distro']         = "rundeck-#{node['rundeck']['version']}.deb"
  default['rundeck']['distro_checksum'] = 'ac1bda18dc2531eaee34a7f45eee1b65a556614727160360f9eda8ef88600959'
when 'rhel'
  default['rundeck']['version']        = '2.6.8-1.20.GA'
  default['rundeck']['downloadpath']   = 'http://dl.bintray.com/rundeck/rundeck-rpm/'
  default['rundeck']['distro']         = "rundeck-#{node['rundeck']['version']}.noarch.rpm"
  default['rundeck']['distro_checksum'] = '2911cc3efacc9dde54e57e7226d5fbd94d96038baa44ad903825299ac87d8c7c'
  default['rundeck']['distro_config']  = "rundeck-config-#{node['rundeck']['version']}.noarch.rpm"
  default['rundeck']['distro_config_checksum'] =
    'aeb047f9b40b91099a5b6ed7f3c658c488d7b6698b4c703c6982874f400b9386'
  default['rundeck']['downloadurl_config']  = node['rundeck']['downloadpath'].to_s +
                                              node['rundeck']['distro_config'].to_s
end

default['rundeck']['downloadurl']    = node['rundeck']['downloadpath'].to_s +
                                       node['rundeck']['distro'].to_s
