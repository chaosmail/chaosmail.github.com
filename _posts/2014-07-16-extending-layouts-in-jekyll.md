---
layout: post
title:  "Extending Layouts in Jekyll"
date:   2014-07-16 21:30:00
categories: github
tags: jekyll liquid disqus
comments: true
---

[Jekyll][jekyll-docs] uses the [Liquid][liquid-wiki] template engine to parse templates. In this blogpost I will discuss how to use Liquid, to customize your blog, to include custom CSS and the framework [Bootstrap][bootstrap-docs]. To enable interaction on our static site, we will also include the commenting system [Disqus][disqus-web].

## Add Excerpt and Read More Link

To add an excerpt text and a read more link to the overview of the posts, we have to output the proper variables in the file *index.html*. In the [Jekyll documentation][jekyll-docs] we can find all the variables, that can be used to output information about the blog, the page or the post.

{% highlight html %}
{% raw %}
<ul class="posts">
{% for post in site.posts %}
  <li>
    <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
    <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
    <span>{{ post.excerpt }}</span>
    <a href="{{ post.url }}">Read more ..</a>
  </li>
{% endfor %}
</ul>
{% endraw %}
{% endhighlight %}

## Including Bootstrap and Custom CSS

We include Bootstrap from the CDN in the file *head.html* in the *_includes* directory.

{% highlight html %}
{% raw %}
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
{% endraw %}
{% endhighlight %}

We then create a file *custom.css* in the directory *css* and link it in *head.html*.

{% highlight html %}
{% raw %}
<link rel="stylesheet" href="{{ "/css/custom.css" | prepend: site.baseurl }}">
{% endraw %}
{% endhighlight %}

Now we can add custom CSS to modify the appearance of the blog.

## Comments

We can embed a commenting system such as [Disqus][disqus-web] to enable user interaction on the blog. To proceed, we have to create an free account on Disqus and a project for our comments.

Next, we embed the comments to the post's template *post.html* in the *_layouts* directory. Pick the current embed code from the [Disqus Administration][disqus-embed] and place it at the end of the file. We will wrap the comments in an *if* block, such that we can enable comments per post.

{% highlight html %}
{% raw %}
{% if page.comments %}
<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'example'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
{% endif %}    
{% endraw %}
{% endhighlight %}

Now we can simply enable the comments in every post with adding *comments: true* to the [YAML][yaml-specs] configuration of the post.

{% highlight yaml %}
---
layout: post
title:  "Extending Layouts in Jekyll"
date:   2014-07-16 21:30:00
categories: github
tags: jekyll liquid disqus
comments: true
---
{% endhighlight %}

## References

* [Jekyll Documentation][jekyll-docs]
* [Liquid Documentation][liquid-docs]
* [Liquid Wiki][liquid-wiki]
* [Bootstrap Documentation][bootstrap-docs]
* [Disqus][disqus-web]
* [Disqus Jekyll Documentation][disqus-jekyll]
* [Disqus Embed Code][disqus-embed]
* [YAML Specification][yaml-specs]

[jekyll-docs]: http://jekyllrb.com/docs/variables/
[liquid-docs]: http://docs.shopify.com/themes/liquid-documentation/basics
[liquid-wiki]: https://github.com/Shopify/liquid/wiki
[bootstrap-docs]: http://getbootstrap.com/
[disqus-web]: https://disqus.com/
[disqus-jekyll]: https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions
[disqus-embed]: http://docs.disqus.com/developers/universal/
[yaml-specs]: http://yaml.org/