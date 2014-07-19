---
layout: post
title:  "Blogging with Jekyll from Github"
date:   2014-07-15 17:30:00
categories: github
tags: github jekyll markdown
comments: true
---

[Jekyll][jekyll-docs] is a simple, blogaware static page-generator written in Ruby. In this blogpost I will discuss how to use Jekyll to blog directly from a Github repository. The advantages are obvious: we don't need to host the blog on a paid webhoster, we don't need to administrate a database, we can use a beautiful markup parser like [markdown][markdown-specs] to write and format blogposts and pushes are automatically published to the personal Github user page [http://chaosmail.github.io](http://chaosmail.github.io).

## Setup

To get started we need *Ruby* and *RubyGems* (Ruby's package manager) installed.

{% highlight bash %}
sudo apt-get install ruby1.9 rubygems1.9
{% endhighlight %}

Now we can install Jekyll via RubyGems.

{% highlight bash %}
gem install jekyll
{% endhighlight %}

We then create a Github repository, that follows following format: *username*.github.com (this automatically makes the blog available on *username*.github.io).

{% highlight bash %}
jekyll new username.github.com 
cd username.github.com
{% endhighlight %}

Now we create a git repository locally and add the remote repository from Github as origin.

{% highlight bash %}
git init 
git remote add origin git@github.com:username/username.github.com.git
{% endhighlight %}

As a next step we look into the basic configuration of our blog to adapt them according to our needs. The configuration is located in the file *_config.yml* in the project's root directory. 

{% highlight bash %}
nano _config.yml
{% endhighlight %}

To locally generate the static pages and preview the blog we run Jekyll's built-in webserver in the project's directory. The *--draft* options additionally enables preview for your drafts.

{% highlight bash %}
jekyll serve --draft
{% endhighlight %}

We can navigate to [http://localhost:4000](http://localhost:4000) to preview the webpage locally. If everything looks fine, we commit the changes and push the blog to Github.

{% highlight bash %}
git add . 
git commit -a -m "Initial Commit"
git push -u origin master
{% endhighlight %}

After a few minutes of processing (the first time usually takes up to 15 minutes), the blog is available on [http://username.github.io](http://chaosmail.github.io).

## The first Post

To write the first blogpost, we create a new file *blogging-with-jekyll.md*  in the *_drafts* directory. The file ending *.md* enables the [markdown][markdown-specs] markup parser. To tell Jekyll, that the file should be parsed as a blogpost, we have to add a special [YAML][yaml-specs] block at the beginning of the file. To understand, how these variables can be used for customizing the blog, read the [Jekyll documentation][jekyll-docs].

{% highlight yaml %}
---
layout: post
title:  "Blogging with Jekyll from Github"
date:   2014-07-15 17:30:00
categories: github
tags: github jekyll markdown
---
{% endhighlight %}

Now we can start using markdown to write and format our blogpost. Once we have finished the draft and we want to publish the post, we add the date in front of the filename *2014-07-15-blogging-with-jekyll.md* and move the file to the *_posts* directory.

We commit the changes and push the blogpost to Github.

{% highlight bash %}
git add _posts/2014-07-15-blogging-with-jekyll.md
git commit -a -m "Added post blogging with jekyll"
git push
{% endhighlight %}

That's all we have to do, to setup a blog on Github and write a first post.

## Further Reading

If you want to use Jekyll for documentations of your Github projects (project pages), it has to be run on the gh-pages branch. Additional Information can be found on the [Github Documentation][jekyll-pages].

There is an interesting project called *Jekyll Bootstrap* that combines the easy scaffolding of Jekyll blogs, adds Twitter Bootstrap and facilitates theming. The project can be found [here][jekyll-bootstrap].

## References

* [Markdown Specification][markdown-specs]
* [YAML Specification][yaml-specs]
* [Jekyll Documentation][jekyll-docs]
* [Jekyll with Github Pages Documentation][jekyll-pages]
* [Jekyll Bootstrap][jekyll-bootstrap]

[markdown-specs]: http://daringfireball.net/projects/markdown/
[yaml-specs]: http://yaml.org/
[jekyll-docs]: http://jekyllrb.com/docs
[jekyll-pages]: https://help.github.com/articles/using-jekyll-with-pages
[jekyll-bootstrap]: http://jekyllbootstrap.com/