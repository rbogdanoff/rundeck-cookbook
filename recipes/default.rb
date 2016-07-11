#
# Cookbook Name:: rundeck
# Recipe:: default
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

# install java - rundeck distro (deb or rpm) has depenency on deb or rpm
# openjdk package.  You can not use community java cookbook and install, say,
# oracle java, as dpkg or rpm will fail when you install rundeck
node.set['java']['jdk_version']    = '7'
include_recipe 'java::default'

# rundeck is not in deb or yum repository - we need to download the distro file from
# rundeck's public artifact repository
remote_file 'rundeck_distro' do
  source node['rundeck']['downloadurl']
  path "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['distro']}"
  checksum node['rundeck']['distro_checksum']
  action :create
end

# install rundeck from the downloaded distro package
case node['platform_family']
when 'debian'
  dpkg_package 'rundeck' do
    source "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['distro']}"
    action :install
  end
when 'rhel'
  remote_file 'rundeck_distro_config' do
    source node['rundeck']['downloadurl_config']
    path "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['distro_config']}"
    checksum node['rundeck']['distro_config_checksum']
    action :create
  end
  rpm_package 'rundeck-config' do
    source "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['distro_config']}"
    options '--nodeps'
    action :install
  end
  rpm_package 'rundeck' do
    source "#{Chef::Config[:file_cache_path]}/#{node['rundeck']['distro']}"
    action :install
  end
end

# rundeck configuration
%w(profile rundeck-config.properties framework.properties).each do |config|
  template config do
    source "#{config}.erb"
    path "#{node['rundeck']['config_dir']}#{config}"
    owner node['rundeck']['user']
    group node['rundeck']['group']
    mode '0640'
    notifies :restart, 'service[rundeckd]', :delayed
  end
end

service 'rundeckd' do
  action [:enable, :start]
end
