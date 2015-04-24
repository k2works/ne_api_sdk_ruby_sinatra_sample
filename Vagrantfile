# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# https://docs.docker.com/userguide/dockerizing/
Vagrant.configure("2") do |config|

  config.vm.define "app" do |app|
    app.vm.network "forwarded_port", guest: 5000, host: 5000

    app.vm.synced_folder '.', '/vagrant'
    app.vm.provider "docker" do |d|
      d.build_dir = '.'
      d.build_args = ['-t', 'k2works/sinatra-env']
      d.cmd = ["rackup","-o","0.0.0.0"]
      d.remains_running = false
    end
  end
end