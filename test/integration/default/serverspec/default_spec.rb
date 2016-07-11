require 'spec_helper'

describe 'rundeck::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  describe 'java' do
    describe 'is installed' do
  	  describe command('java -version') do
        its(:exit_status) { should eq 0 }
      end
    end
    describe 'is version 7' do
      describe command('java -version') do
        its(:stderr) { should match /java version "1\.7/}
      end
    end
  end

  describe 'rundeck_disto' do
  	describe 'downloaded' do
  	  # the expected rundeck distro file will be somewhere in /tmp
  	  # it depends where the chef cache is located
  	    describe command("find /tmp -regex '.*\/cache\/rundeck-.*..[deb|rpm]'") do
  	      its(:stdout) { should match /\/cache\/rundeck-.*.[deb|rpm]/}
  	    end
  	 end
   end

  describe package('rundeck') do
    it { should be_installed }
  end

  describe service('rundeckd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe 'the rundeck application' do
  	# it can a few seconds for rundeckd to start
  	# so lets wait
    puts('waiting 60 seconds to make sure rundeckd has finished starting...')
  	sleep(60)
  	describe port(4440) do
      it { should be_listening }
    end
  end

end
