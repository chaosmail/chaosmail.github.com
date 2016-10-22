---
layout: post
title:  "Automating IT-Infrastructure with Vagrant and Puppet"
date:   2014-08-03 16:00:00
categories: programming
tags: vagrant puppet
comments: true
---

Setting up multiple development environments is a pain. Often, we have to deal with multiple settings, multiple library versions and overlapping dependencies for different projects. [Vagrant][vagrant-web] is a tool written in Ruby for managing multiple development environments as virtual machines on your local machine. It manages all the steps from creating virtual images to launching them, syncing of local folders and port forwarding. In this blogpost I will discuss how to set up Vagrant together with the provisioning tool [Puppet][puppet-web] to create  automated development environments, that can be checked in into version control. A working demo of the configuration of a simple webstack (nginx, php-fpm, mysql) can be found [on Github][chaosmail-webstack-demo].

## What is Vagrant?

Vagrant is a brilliant tool for controlling your development virtual machines and wiring them with the host operating system. Directory syncing and port forwarding are just two of a variety of nice features, that boost your development work flow. With a simple *vagrant up* it creates for everyone the exact same developing environment, that can be checked in into version control together with a project and used by all the team members of the project.

Vagrant uses a [provider](http://docs.vagrantup.com/v2/providers/index.html) to run the virtual machines; in our example this will be Virtualbox. For the creation of the environment Vagrant starts from a base [box](http://docs.vagrantup.com/v2/boxes.html) (e.g. a plain Ubuntu iso or a community box) and applies automated software changes via a [provisioning](http://docs.vagrantup.com/v2/provisioning/index.html) tool on top of the base box.

## Getting Started with Vagrant

To get started we need *Ruby* and *RubyGems* (Ruby's package manager) installed.

{% highlight bash %}
sudo apt-get install ruby1.9 rubygems1.9
{% endhighlight %}

Next we install *Virtualbox*, that will be used as a provider for Vagrant.

{% highlight bash %}
sudo apt-get install virtualbox 
{% endhighlight %}

Now we can install *Vagrant*. Therefore we grab the latest binaries from the [Vagrant installation guide](https://docs.vagrantup.com/v2/installation/) and install them.

We can create a virtual machine image with running *vagrant init* in a project's folder. This will create a *Vagrantfile*, a file the stores the configuration of the wiring with the host operating system, provisioning methods and more configurations about the virtual machine.

{% highlight bash %}
mkdir my_app && cd my_app
vagrant init
{% endhighlight %}

To get detailed information of the configuration, please check the [nice documentation][vagrant-docs] of Vagrant. To start your virtual development environment run *vagrant up*.

{% highlight bash %}
vagrant up
{% endhighlight %}

After a few minutes, your virtual machine is ready and running. You can now ssh into it with the *vagrant ssh* command.

{% highlight bash %}
vagrant ssh
{% endhighlight %}

## And what is Puppet?

[Puppet][puppet-web] is a provisioning tool for automating software installations and configurations written in Ruby. Puppet lets you describe the software changes (installing libraries, configuring services, manipulating files, etc.), that you want to  apply to a system. This allows you to automatically make the exact same changes on multiple machines.

There exist a lot of other provisioning tools (Chef, Ansible, etc.) that can be also used with vagrant. I chose Puppet because its client for a single workstation (that's most probably what we need when we use Vagrant) is simple in describing infrastructure while having a very clean and organized way to manage environments in the same git repository as the project. In particular, I am aiming for a project structure in small web projects like the following:

- project_root
  - env 				*(Directory holds the development environments)*
  - web-app				*(Directory holds the main web application)*
  - email-worker		*(Various workers for different tasks)*
  - database-worker
  - more-workers..

In the later example, we will use the tool [Librarian-Puppet][librarian-puppet] to put all the dependencies to a *Puppetfile*. We can then use it to install all the dependencies to the modules directory, so we do not have to include the *modules* directory to the git repository. The structure of the environment folder looks like this

- project_root
  - env
    - puppet 			*(Directory holds all Puppet specific files)*
    	- modules		*(Puppet dependencies)*
    	- nodes
    	- manifests
    	- Puppetfile	*(File holds Puppet specific dependencies)*
    - config.yaml 		*(File holds all (common) configurations)*
    - Vagrantfile		*(File holds Vagrant specific configurations)*

In the *nodes* directory we will later store the configurations for the different services on our nodes and in the *manifests* directory we will place the configuration for a single machines, that defines which nodes are used on this machine.

## Installing Puppet

We install *Puppet* and *Librarian-Puppet* via RubyGems.

{% highlight bash %}
gem install puppet
gem install librarian-puppet
{% endhighlight %}

We can now automatically install software on our machines. Therefore we can search on [Puppet Forge][puppet-forge] or Github for existing modules, that we can add to our *Puppetfile*. Please check out the [demo project][chaosmail-webstack-demo] on Github or the [Puppet Documentations][puppet-docs] for more details.

## The Vagrant Workflow

Now I will demonstrate the workflow with Vagrant on a sample web application. First, we need to set up the project, therefore we check out the [demo application][chaosmail-webstack-demo] from Github.

{% highlight bash %}
git clone https://github.com/chaosmail/vagrant-puppet-webstack
{% endhighlight %}

We then navigate to the *puppet* directory and install the dependencies with Librarian-Puppet. This will pull the dependencies and place them into the *modules* directory.

{% highlight bash %}
cd vagrant-puppet-webstack/env/puppet
librarian-puppet install
{% endhighlight %}

In this example, we are using the hostmanager plugin from Vagrant, that automatically manages the configuration of our local hosts file. We can install it via Vagrant's plugin manager.

{% highlight bash %}
vagrant plugin install vagrant-hostmanager
{% endhighlight %}

Now, we change to the *env* directory and run *vagrant up*. This will download the Ubuntu base box (when run the first time), sync the project's directories, forward the ports and sets up and configures the webstack.

{% highlight bash %}
cd ..
vagrant up
{% endhighlight %}

That's all. We can navigate to [http://my-app.dev/](http://my-app.dev/) to see the webstack (and the application) running.

Use *vagrant provision* to apply changes of your Vagrantfile without restarting the virtual machine. Use *vagrant suspend* and *vagrant resume* the freeze and resume your virtual machine.

Use *vagrant ssh* to ssh into the development machine.

## Further Readings

[PuPHPet][puphpet-web] is an awesome free online generator for Vagrant and Puppet configurations for webstacks (Nginx/Apache, PHP, MySQL/Postgresql, RabbitMQ, Redis, etc.).

Useful plugins for working with Vagrant are [vagrant-hostmanager][vagrant-hostmanager] (automatically configure the host's hosts file through vagrant) or anyone from [this list][vagrant-plugins] that fits your needs.

Instead of writing a plain *config.yaml* file, one might be interested in writing hierarchical configurations. This can be easily achieved with [hiera][puppetlabs-hiera].

## References

* [Vagrant][vagrant-web]
* [Vagrant Documentation][vagrant-docs]
* [Puppet][puppet-web]
* [Puppet Documentation][puppet-docs]
* [Puppet Forge][puppet-forge]
* [Linux.com Tutorial on Puppet][linux-puppet-tutorial]
* [Virtualbox][virtualbox-web]
* [Scotch Tutorial on Vagrant][scotch-vagrant]
* [Librarian-Puppet][librarian-puppet]
* [Github Demo Configuration of Webstack][chaosmail-webstack-demo]
* [PuPHPet][puphpet-web]
* [Vagrant-Hostmanager Plugin][vagrant-hostmanager]
* [Mitchell Hashimoto's List of Vagrant Plugins][vagrant-plugins]
* [Pluggable Hierarchical Database][puppetlabs-hiera]

[vagrant-web]: http://www.vagrantup.com/
[vagrant-docs]: http://docs.vagrantup.com/v2/
[puppet-web]: http://puppetlabs.com/
[puppet-docs]: http://docs.puppetlabs.com/puppet/
[puppet-forge]: https://forge.puppetlabs.com/
[linux-puppet-tutorial]: http://www.linux.com/news/software/applications/694157-setup-your-dev-environment-in-nothing-flat-with-puppet
[virtualbox-web]: https://www.virtualbox.org/
[scotch-vagrant]: http://scotch.io/tutorials/get-vagrant-up-and-running-in-no-time
[librarian-puppet]: https://github.com/rodjek/librarian-puppet
[chaosmail-webstack-demo]: https://github.com/chaosmail/vagrant-puppet-webstack
[puphpet-web]: https://puphpet.com/
[vagrant-hostmanager]: https://github.com/smdahlen/vagrant-hostmanager
[vagrant-plugins]: https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins
[puppetlabs-hiera]: https://github.com/puppetlabs/hiera