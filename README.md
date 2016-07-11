rundeck cookbook
================

This chef cookbook will do a basic installation of Rundeck.  Rundeck is a job scheduler/automator
http://rundeck.org/

Usage
-----

Just include 'rundeck::default' in your runlist


Vagrant
-------

If you want to take a look at Rundeck, you can just use the provided vagrantfile

### requirements
You will need
* the chefdk
* vagrant
* virtualbox
* the vagrant berkshelf plugin
```bash
$ vagrant plugin install vagrant-berkshelf
```

Once you have the above requirements just do...
```bash
$ vagrant up
```

Then, point your browser to http://192.168.33.10:4440
it may take a few seconds after vagrant finishes for the rundeck application to start

The initial username/password to log into the rundeck webapp is admin/admin

see http://rundeck.org/docs/manual/getting-started.html


Platforms Supported
-------------------
I have been testing with
* ubuntu 14.01
* centos 7.1

I suspect that the Debian and rhel family will work but I thus far have only tested the above


Attributes
----------
For the complete list see attributes/default.rb

The ones you may be interested in for now
* `node['rundeck']['http_port']` - the port the rundeck web app listens on.  Default is 4440
* `node['rundeck']['log_level']` - log level of the rundeck application. Default is INFO
* `node['rundeck']['jvm_runtime_opts']` - Additional JVM runtime parameters you may want to use. Default is -Xmx1024m -Xms256m -XX:MaxPermSize=256m

Testing
-------
If you have the above requirements as listed in the Vagrant section you can run the tests
```
$ rubocop
$ foodcritic .
$ rspec
$ kitchen test
```

TODO
----
07/10/2016
I have thrown this project together over the last day or two, it is still basic.
* Will be adding targets in the thorfile for running the tests as a complete suite
* Need to add many more config attributres 
* Need to add another recipe for a reverse proxy server
* https support
* etc.





