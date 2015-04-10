---
layout: post
title:  "Running Python3 and Pip on Ubuntuphone"
date:   2015-04-09 18:00:00
categories: programming
tags: python pip ubuntuphone
comments: true
---

The [Aquaris E4.5 ubuntuphone][aquaris-web] ships with a pre-installed python3 interpreter. However, this embedded interpreter lacks the [package manager pip][pip-docs] - a common tool to install new python modules. In this blogpost, I will show how to install pip and setuptools on the ubuntuphone.

## Getting Started

First, we need a terminal on the phone. Go to the *Ubuntu Store* and download the *Terminal* app. Now start the app from the *application scope* and type ```python3 --version```. We should see an output similar to *Python 3.4.1+*.

If we try to run ```pip3``` or ```python3 -m pip```, we will see an error message because pip is not installed.

## Installing Pip and Setuptools

Download the self-included pip binary setup script with *wget* as recommended on the [pip installer][pip-installer] page.

```
wget https://bootstrap.pypa.io/get-pip.py
```

Now configure *pip* to always use the *--user* flag, in order to install everything to the *~/.local* directory rather than the read-only */usr* directory. This allows us also to run pip without the need for *sudo*. We will write a *pip.conf* file to handle this for us.

```
mkdir -p .config/pip
echo -e "[install]\nuser = true" > .config/pip/pip.conf
```

Next, you can run the pip installer to install and update itself.

```
python3 get-pip.py
```

You should now see an output saying *Successfully installed pip setuptools*. Finally, you can call *pip* with the *python3 -m* command to install packages from [PyPi][pypi-web].

```
python3 -m pip install requests
```

## Limitation

Due to the lack of compiling tools on the phone, we are not able to install any packages with *pip* that need to be compiled, such as *numpy*. These packages need to be cross-compiled and copied on the phone manually.

When, we want to call *pip* directly - instead of using the *python -m pip* command - we need to add the *~/.local/bin* directory that contains the pip binary to the path.

```
echo -e "PATH=$PATH:$HOME/.local/bin\nexport PATH" >> .bashrc
```
Now, if we restart the terminal we can use the *pip* command directly from the termnial. However, when we execute the *pip* command in the terminal, we will receive a *bad interpreter, permission denied* error message. As a workaround, we need to use the odd *python3 -m pip* command.

## Useful Shortcuts

If we want also the *python* command available rather than *python3* we need to link it to the *.local/bin* directory (and add this directory to the path, what we did in the previous section).

```
ln -s /usr/bin/python3 .local/bin/python
```

After restarting the Terminal app, we can use the *python* command.

## References

* [Aquaris][aquaris-web]
* [Pip Docs][pip-docs]
* [Pip Installer][pip-installer]
* [PyPi][pypi-web]

[aquaris-web]: http://www.bq.com/gb/ubuntu.html
[pip-docs]: https://pip.pypa.io/en/stable/
[pip-installer]: https://pip.pypa.io/en/latest/installing.html
[pypi-web]: https://pypi.python.org/pypi