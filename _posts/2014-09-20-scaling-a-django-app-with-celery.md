---
layout: post
title:  "Scaling a Django App with Celery"
date:   2014-09-20 22:00:00
categories: programming
tags: django celery rabbitmq
comments: true
---

[Celery][celery-web] is a library for asynchronous task and worker queues and scheduling based on distributed message passing infrastructure like [RabbitMQ][rabbitmq-web] (or Redis) written in Python. It facilitates the distribution of work of intensive parts of the application among different processes to horizontally scale an application across all systems. Celery can easily be integrated to a [Django][django-web] application to make it more responsive, distributed and scalable.

## Getting Started with Celery

First, we install Celery with the PIP Package Manager.

{% highlight bash %}
pip install celery
{% endhighlight %}

> Disclaimer: Since Celery 3.1 we don't need to add the package celery-django to the Django application anymore. Everything works fine with solely the Celery package.

Now we add the file *celery.py* for the global configuration of Celery to the project folder *my_project*; the structure of project directory now looks like this:

- setup.py
- requirements.txt
- my_project
  - manage.py
  - my_project
    - \_\_init\_\_.py
    - *celery.py*
    - settings.py
    - urls.py
    - views.py
    - wsgi.py

To tell Celery it should start the workers with the settings of *my_project* we modifiy the *celery.py* file to look like this:

{% highlight python %}
from __future__ import absolute_import
import os
from celery import Celery
from django.conf import settings

# set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'my_project.settings')

app = Celery('my_project')

# Using a string here means the worker will not have to
# pickle the object when using Windows.
app.config_from_object('django.conf:settings')
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS) 
{% endhighlight %}

## Configure a Message Passing System

Celery relies on an existing messages passing system; in this example we use [RabbitMQ][rabbitmq-web] as a reliable and scalable infrastructure.

{% highlight bash %}
sudo apt-get install rabbitmq-server
{% endhighlight %}

This installs and starts RabbitMQ on it default port 5672 and a user *guest* with password *guest* preconfigured for local use. We can check the [RabbitMQ documentation][rabbitmq-docs] and adapt the settings according to our needs.

{% highlight bash %}
sudo nano /etc/rabbitmq/rabbitmq.config
{% endhighlight %}

Now, we need to configure a *BROKER_URL* in the settings of the Django project, so we add following configuration to the *settings.py* file:

{% highlight python %}
# Define the Queue Settings
QUEUES = {
    'default': {
        'ENGINE': 'rabbitmq',
        'NAME': 'my_project',
        'USER': 'guest',
        'PASSWORD': 'guest',
        'HOST': 'localhost',
        'PORT': '5672',
    }
}

# Generate the Broker Url
BROKER_URL = 'amqp://' + QUEUES['default']['USER'] + ':' + QUEUES['default']['PASSWORD'] + '@' + QUEUES['default']['HOST'] + ':' + QUEUES['default']['PORT'] + '/' + QUEUES['default']['NAME']
{% endhighlight %}

## Adding Tasks for Workers

We want Celery to distribute intensive tasks from the *my_app* application of the *my_project* project among all systems; therefore we need to tell Celery which tasks should be executed by asynchronous workers. We add a *tasks.py* file to the application specific directory *my_app*.

- setup.py
- requirements.txt
- my_project
  - manage.py
  - my_app
    - \_\_init\_\_.py
    - *tasks.py*
    - admin.py
    - models.py
    - urls.py
    - views.py
    - tests.py
  - my_project
    - \_\_init\_\_.py
    - celery.py
    - settings.py
    - urls.py
    - views.py
    - wsgi.py

We create a function *run_task* that starts the work intensive task and a success and error callback - that are again executed asynchronously - inside the *tasks.py*.

{% highlight python %}
from __future__ import absolute_import

from celery import shared_task
from some_project import my_intensive_task
from my_app.models import my_model

@shared_task
def run_task():

    # What we return here, will be available as an argument
    # in the success callback function
    return my_intensive_task()

@shared_task
def on_success_task(result):

    # We could store the results in the database
    # in a model, if we want; therefore we have to
    # return the id of the model somewhere in the results
    my_model = MyModel.objects.get(id = result["id"])
    my_model.results = results    
    my_model.save()

    print "Task finished successfully"

@shared_task
def on_error_task():
    print "Task finished with error"

{% endhighlight %}

Now, we can call these asynchronous tasks anywhere in the Django project via

{% highlight python %}
from tasks import run_task, on_success_task, on_error_task

# Configure Task and Callbacks
s = run_task.s(args)
s.link(on_success_task.s())
s.link_error(on_error_task.s())

# Start Task asynchronously
task_id = s.apply_async()
{% endhighlight %}

> This syntax uses the signature method *s* to add the callbacks and execute the task asynchronously. If you don't want to apply callbacks, check out the [Celery documentation][celery-docs] for an easier syntax like *run_task.apply_async(args, kwargs, **options)*!

## Run the Workers

To run a worker daemon that is waiting for tasks to execute, simply start celery in the root folder of the project.

{% highlight bash %}
celery -A my_project worker -l info
{% endhighlight %}

## References

* [Celery][celery-web]
* [Celery Documentation][celery-docs]
* [Celery Documentation: Django][celery-docs-django]
* [RabbitMQ][rabbitmq-web]
* [RabbitMQ Documentation][rabbitmq-docs]
* [Django][django-web]
* [Michał Karzyński's Blogpost on Celery and Django][michal-blog]

[celery-web]: http://www.celeryproject.org/ 
[celery-docs]: http://docs.celeryproject.org/
[celery-docs-django]: http://celery.readthedocs.org/en/latest/django/first-steps-with-django.html
[rabbitmq-web]: http://www.rabbitmq.com/
[rabbitmq-docs]: http://www.rabbitmq.com/documentation.html
[django-web]: https://www.djangoproject.com/
[michal-blog]: http://michal.karzynski.pl/blog/2014/05/18/setting-up-an-asynchronous-task-queue-for-django-using-celery-redis/
