---
layout: post
title:  "Installing Visual Studio Code on Ubuntu"
date:   2015-09-29 11:00:00
categories: web development
tags: vscode
comments: true
---

[Visual Studio Code][vscode-web] is an open source multi-platform IDE for web development (especially JavaScript and Typescript) - enough reasons for me to check it out.

## Installing

Download the latest Version from the [Visual Studio Code][vscode-web] website (I found the 64 bit version on the [update page][vscode-update]) and unzip it.

Then move it to the *opt/* directory and create a symbolic link.

{% highlight bash %}
sudo mv VSCode-linux-x64 /opt/VSCode
sudo ln -s /opt/VSCode/Code /usr/local/bin/code
{% endhighlight %}

You are done; just run `code` from your terminal!

## Creating a Desktop Icon

Create a desktop Icon by creating a *VSCode.desktop* file

{% highlight bash %}
sudo gedit /usr/share/applications/VSCode.desktop
{% endhighlight %}

with the following content

{% highlight ini %}
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/opt/VSCode/Code
Name=VSCode
Icon=/opt/VSCode/resources/app/vso.png
Categories=Development
{% endhighlight %}

Now you can find VSCode in your start menu.

## References

* [Visual Studio Code Website][vscode-web]
* [Visual Studio Code Updates][vscode-update]
* [Visual Studio Code on Stackoverflow][vscode-so]

[vscode-web]: https://code.visualstudio.com/
[vscode-update]: https://code.visualstudio.com/Docs/supporting/howtoupdate
[vscode-so]: http://askubuntu.com/questions/616075/how-to-install-visual-studio-code-on-ubuntu