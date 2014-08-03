---
layout: post
title:  "Adding Animations in AngularJS"
date:   2014-07-20 13:50:00
categories: programming
tags: angularjs animation
comments: true
---

[AngularJS][angular-web] is a superheroic web framework written in JavaScript that enables declarative dynamic web views in HTML by extending the HTML vocabulary. One of its great features is automatic [data-binding][angular-docs-databind] of models and templates. In this blogpost I will discuss how to extend an existing AngularJS application to support animations. A working demo can be found [here][chaosmail-animation-demo].

## Adding Animations in AngularJS 1.2

> Disclaimer: Animations in AngularJS 1.2 are different than in older versions of AngularJS. Please follow the tutorial on [Year of Moo](http://www.yearofmoo.com/2013/04/animation-in-angularjs.html) to use animations with older versions of AngularJS.

In AngularJS 1.2 animations are not part of the core library anymore, so the animation package has to be included additionally. We install angular-animate via the Bower package manager.

{% highlight bash %}
bower install angular-animate
{% endhighlight %}

Now, we load the animation package together with the AngularJS core library.

{% highlight html %}
<html ng-app="MyApp">
<head>
<script src="bower_components/angular/angular.js"></script>
<script src="bower_components/angular-animate/angular-animate.js"></script>
</head>
<body>
...
</body>
</html>
{% endhighlight %}

We have to register the animation package in the application, so we add *ngAnimate* as a dependency in the initialization of the *MyApp* application.

{% highlight javascript %}
var myApp = angular.module('MyApp', ['ngAnimate']);
{% endhighlight %}

After these steps, we have animation enabled in the application and we can use CSS classes to define the elements that should be animated. The animations itself are declared with CSS transitions.

## Animating Elements in ngRepeat

To enable animations in an existing ngRepeat directive, we simply add a CSS class *anim*.

{% highlight html %}
{% raw %}
<div ng-repeat="item in items" class="anim">
  {{ item.id }}
</div>
{% endraw %}
{% endhighlight %}

We now define the CSS transition of the class *anim*.

{% highlight css %}
/* you can also define the transition style
   on the base class as well (.anim) */
.anim.ng-enter,
.anim.ng-leave {
  -webkit-transition:0.5s linear all;
  transition:0.5s linear all;
}

.anim.ng-enter,
.anim.ng-leave.ng-leave-active {
  opacity:0;
}
.anim.ng-leave,
.anim.ng-enter.ng-enter-active {
  opacity:1;
}
{% endhighlight %}

That's all we have to do, to add animations to an existing AngularJS application. A working demo of this example can be found [here][chaosmail-animation-demo].

## Further Readings

I strongly recommend to read the tutorial on [Year of Moo][yom-blog] on animations in AngularJS and the [official documentation][angular-docs-animation] itself. 

Various built-in timing functions can be used to customize CSS transitions. Please read the specification on [timing functions in CSS][css-timing-specs] or the tutorial on cubic bezier curves in CSS on [Hongkiat's blog][hongkiat-bezier].

To quickly add more fancy animations, you can include [Animate CSS][animatecss-web], a predefined set of CSS transitions - ready to use.

## References

* [AngularJS][angular-web]
* [AngularJS Documentation on Data-Binding][angular-docs-databind]
* [AngularJS Documentation on Animation][angular-docs-animation]
* [Year of Moo Tutorial on Animation][yom-blog]
* [CSS Transitions][css-trans-specs]
* [Plunker Demo on Animation][chaosmail-animation-demo]
* [CSS Transition Timing Functions][css-timing-specs]
* [Hongkiat Tutorial on Cubic Bezier Curves in CSS][hongkiat-bezier]
* [Animate CSS][animatecss-web]

[angular-web]: https://angularjs.org/
[angular-docs-databind]: https://docs.angularjs.org/guide/databinding
[angular-docs-animation]: https://docs.angularjs.org/guide/animations
[yom-blog]: http://www.yearofmoo.com/2013/08/remastered-animation-in-angularjs-1-2.html
[css-trans-specs]: http://www.w3schools.com/css/css3_transitions.asp
[chaosmail-animation-demo]: http://plnkr.co/hCMPIpUvuUO6CbhQfBbJ
[css-timing-specs]: http://www.w3schools.com/cssref/css3_pr_transition-timing-function.asp
[hongkiat-bezier]: http://www.hongkiat.com/blog/css-cubic-bezier/
[animatecss-web]: http://daneden.github.io/animate.css/