---
layout: post
title:  "Install .deb Packages in Ansible"
date:   2015-03-04 09:00:00
categories: programming
tags: ansible ubuntu deb
comments: true
---

[Ansible][ansible-web] is a very simple, clean and elegant tool to provision your production or development machines. It can be also used to setup and configure your development desktop, for example from a plain Ubuntu 14.04 LTS installation. For this task, we will soon run into the need to check, download and install applications as .deb packages because there is no ppa repository available (e.g. for dropbox, vagrant, etc.). In this blogpost, I will discribe how I solved this problem using Ansible.

## Checking if .deb Package is already installed

We want to install the package *my_package* - so first, we need to make sure that it is not yet already installed. We will use the bash command ```dpkg-query -W my_package``` to check for the availability of the package. We also want to register the output of this command - which can be done with the *register* statement in Ansible - in order to use the output as a conditional statement for other tasks.

{% highlight yaml %}
{% raw %}
- name: Check if my_package is installed
  command: dpkg-query -W my_package
  register: my_package_check_deb
  failed_when: my_package_check_deb.rc > 1
  changed_when: my_package_check_deb.rc == 1
{% endraw %}
{% endhighlight %}

In the above code, I added the *failed_when* statement, to not let the command fail when it exits with an error code *1* - which means the package was not found. Additionally, we set the *changed_when* statement, to return the state *changed* only when the package is not found.

## Downloading and installing a .deb package

Once we know that a package is not yet installed, we want to download and install it. To do so, we will use the 2 variables *my_package_url* and *my_package_name* that we need to register somewhere (preferably in the *vars/* directory of the current *role*) and the *get_url* module from Ansible. We solely want to download the file, if it is not already installed - which we can check with the *when* statement and the previously registered *vagrant_check_deb* variable. We can check the return code from a registered command by using the *.rc* attribute. 

{% highlight yaml %}
{% raw %}
- name: Download my_package
  get_url: 
    url="{{ my_package_url }}"
    dest="/home/{{ ansible_env.USER }}/Downloads/{{ my_package_name }}.deb"
  when: vagrant_check_deb.rc == 1
{% endraw %}
{% endhighlight %}

Finally, we install the package - again just if the package was not previously installed.

{% highlight yaml %}
{% raw %}
- name: Install my_package
  apt: deb="/home/{{ ansible_env.USER }}/Downloads/{{ my_package_name }}.deb"
  sudo: true
  when: vagrant_check_deb.rc == 1
{% endraw %}
{% endhighlight %}

## Further Readings

This technique is used in my project *dev-env*, a Ansible based installer for a local development environment. The source code of this project and the complete Ansible configuration and roles can be found on [GitHub](http://github.com/chaosmail/dev-env).

## References

* [Ansible][ansible-web]
* [Ansible documentation on conditionals][ansible-docs-conditionals]
* [Ansible module get_url][ansible-module-get_url]
* [Ansible module apt][ansible-module-apt]

[ansible-web]: http://www.ansible.com/
[ansible-docs-conditionals]: http://docs.ansible.com/playbooks_conditionals.html
[ansible-module-get_url]: http://docs.ansible.com/get_url_module.html
[ansible-module-apt]: http://docs.ansible.com/apt_module.html