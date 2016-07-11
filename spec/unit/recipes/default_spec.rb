#
# Cookbook Name:: rundeck
# Spec:: default
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

require 'spec_helper'

describe 'rundeck::default'  do
  describe 'debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
        .converge(described_recipe)
    end
  
    it 'includes the java recipe' do
       expect(chef_run).to include_recipe('java::default')
    end
  
    it 'downloads the rundeck distro' do
      expect(chef_run).to create_remote_file('rundeck_distro')
        .with(source: 'http://dl.bintray.com/rundeck/rundeck-deb/rundeck-2.6.8-1-GA.deb')
    end
  
    it 'installs the rundeck package' do
    	 expect(chef_run).to install_dpkg_package('rundeck')
    end

    %w(profile rundeck-config.properties framework.properties).each do |config|
      describe config do
        let(:rundeck_config_template) { chef_run.template(config) }
        it 'creates from a template' do
           expect(chef_run).to create_template(config).with(
             user:   'rundeck',
             group:  'rundeck',
             mode:   '0640'
           )
           expect(rundeck_config_template).to notify('service[rundeckd]').delayed
        end
      end
    end

    it 'enables and starts the rundeckd service' do
      expect(chef_run).to enable_service('rundeckd')
      expect(chef_run).to start_service('rundeckd')
    end
  end

  # test the specifics for rhel
  describe 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
        .converge(described_recipe)
    end
  
    it 'downloads the rundeck config distro' do
      expect(chef_run).to create_remote_file('rundeck_distro_config')
        .with(source: 'http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-config-2.6.8-1.20.GA.noarch.rpm')
    end

    it 'downloads the rundeck distro' do
      expect(chef_run).to create_remote_file('rundeck_distro')
        .with(source: 'http://dl.bintray.com/rundeck/rundeck-rpm/rundeck-2.6.8-1.20.GA.noarch.rpm')
    end

    it 'installs the rundeck config package' do
    	 expect(chef_run).to install_rpm_package('rundeck-config')
    end
  
    it 'installs the rundeck package' do
    	 expect(chef_run).to install_rpm_package('rundeck')
    end
  end

end