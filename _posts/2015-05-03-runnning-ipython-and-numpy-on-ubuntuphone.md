---
layout: post
title:  "Running IPython and Numpy on Ubuntuphone"
date:   2015-05-03 20:00:00
categories: programming
tags: python ipython numpy ubuntuphone
comments: true
---

In my previous blogpost, I wrote about installing *Pip* for the built-in *python3* interpreter on the ubuntuphone. One serious limitation with *Pip* is that we cannot install precompiled binary packages such as *Numpy*. Moreover, `apt-get install` does not work on the ubuntuphone due to the read-only filesystem. In this blogpost, I will show how to make the filesystem writable and to use `apt-get install` to install a precompiled version of *Numpy* on ubuntuphone. After installing *gcc* and *g++*, we can simply use `pip` to install any package, for example *IPython*.

## Before getting started

If you haven't followed my previous blogpost, please download and install the *Terminal* application from the *Ubuntu store*.

Next, configure *Pip* to use the *~/.local* directory for installing packages. We can do this, by opening the *Terminal* application and executing the following lines.

We create a folder for the configuration.

```
mkdir -p .config/pip
```

Then, we write a configuration file.

```
echo -e "[install]\nuser = true" > .config/pip/pip.conf
```

## Writable Filesystem (Run this commands from the computer!)

First, please make sure to backup all your files and system data from the device before you continue!

Now we will mount a [writable root directory][ubuntu-devices] on the ubuntuphone. For this task we need to use an ubuntu laptop and we need to install the *phablet-tools* package on the host machine.

```
sudo apt-get install phablet-tools
```

Then, connect the phone with USB, unlock the screen, and enable the developer mode in the settings. Now, run the following command from the host machine to make the filesystem writable.

```
phablet-config writable-image
```

The phone will restart and boot with a writable filesystem. This means, now, we can use `sudo apt-get install` command on the phone to install precompiled system (and python) packages.

## Installing Python2, Pip and build tools

First, we install *Python*, *Python headers* and the *gcc* compiler.

```
sudo apt-get install python python-dev gcc g++
```

Now we install the *pip* package manager - we will use the recommended [pip installer][pip-installer].

```
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

You should now see an output saying *Successfully installed pip setuptools*. Finally, you can call *pip* with the *python -m* command to install any package from [PyPi][pypi-web].

## Installing Numpy

To start with, we want to install a precompiled version of *Numpy*. That's very easy, we simply have to exectue the following command from the *Terminal* application.

```
sudo apt-get install python-numpy
```

## Installing IPython

Next, we can install *IPython* and the *IPython Notebook* using the *Pip* package manager.

```
python -m pip install ipython[notebook]
```

We should no be able to run *IPython* with the *python -m* command. However, the *Terminal* application is closing every running task as soon you switch to another app. Therefore, we have to detach the notebook from the terminal with appending the `&` command.

```
python -m pip IPython notebook &
```

Let's open a browser and navigate it to *http://localhost:8888/* (the trailing slash is important!).

![ipython on ubuntuphone](https://raw.github.com/chaosmail/chaosmail.github.com/master/images/up-jupyter-00.png "IPython on Ubuntuphone")

We can now try to create a new file, import *Numpy* and run it.

![numpy on ubuntuphone](https://raw.github.com/chaosmail/chaosmail.github.com/master/images/up-jupyter-01.png "numpy on Ubuntuphone")

## More Scientific Stuff

Go on, install *SKlearn*, *Scipy* and all the stuff that you need!

## Find more precompiled Libraries

It is very easy to search for precompiled python libraries with `apt-cache search`. To search for a package *libname*, we have to execute the following command.

```sudo apt-cache search python | grep libname```

## References

* [Pip Installer][pip-installer]
* [PyPi][pypi-web]
* [Ubuntu for devices][ubuntu-devices]

[pip-installer]: https://pip.pypa.io/en/latest/installing.html
[ubuntu-devices]: https://developer.ubuntu.com/en/start/ubuntu-for-devices/installing-ubuntu-for-devices/
[pypi-web]: https://pypi.python.org/pypi