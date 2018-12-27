---
layout: page
title: Projects
permalink: /projects/
---

Here is an overview of some of the open source projects that I worked on during the past years.

## Tensorflow.js ONNX Runner

After successfully running pre-trained Caffe models in the browser without any modifications, I thought about a more general approach of porting pre-trained models to the web. Hence, I decided to look into the [ONNX][web-onnx] (Open Neural Net Exchange Format) specification. ONNX is a format aimed for interchanging pre-trained models between different runtimes and looks perfect for my use-case.

The [Tensorflow.js ONNX Runner][github-tfjs-onnx] is a proof of concept implementation for running arbitrary ONNX models in the browser using [Tensorflow.js][github-tfjs]. This means that we could run any model from any framework supporting ONNX (PyTorch, Caffe2, CNTK, Tensorflow, Core ML etc.) in the browser without modification.

The code is as simple as loading the ONNX model from a path and using it as a Tensorflow model - as shown in the following example:

```javascript
var modelUrl = 'models/squeezenet/model.onnx';

// Initialize the tf.model
var model = new onnx.loadModel(modelUrl);

// Now use tf.model
const pixels = tf.fromPixels(img);
const predictions = model.predict(pixels);
```

For production use-cases, a better approach would be to convert the ONNX model to a tfjs model using the [Tensorflow.js converter module][github-tfjs-converter]. This also allows the developers to optimize the model for the usage in the browser.

[github-tfjs-onnx]: https://github.com/chaosmail/tfjs-onnx
[github-tfjs]: https://github.com/tensorflow/tfjs
[github-tfjs-converter]: https://github.com/tensorflow/tfjs-converter
[web-onnx]: https://onnx.ai/

## CaffeJS - Running Caffe models in the browser

[CaffeJS][github-caffejs] started as a proof of concept for porting Caffe models to the browser using a modified version of [ConvNetJS (by Andrej Karpathy)](http://convnetjs.com). At first, I only wanted to parse Caffe architectures from `*.prototxt` in order to [visualize and analyze](https://chaosmail.github.io/caffejs/models.html) the flow of activations through the network.

![Analyze the inception module]({{ site.baseurl }}/images/projects/inception.png "Analyze the inception module"){: .image-col-1}

After diving deep into DL model structures, I wondered if I could manage to load the model weights within JavaScript and perform a simple CPU based forward pass entirely in the browser. Turns out, that typed arrays in JavaScript are very powerful and can easily handle model weights from GoogLeNet to AlexNet models. I had to extend the ConvNetJS architecture to support DAG structures but I could reuse most of the Layer implementations. Here are screenshots of running an ImageNet classification task using a pretrained GoogLeNet and the `getUserMedia` API (to access the webcam in the browser) on a Desktop and mobile phone.

![CaffeJS browser]({{ site.baseurl }}/images/projects/caffejs.png "CaffeJS browser"){: .image-col-2}
![CaffeJS Android]({{ site.baseurl }}/images/projects/caffejs-android.png "CaffeJS Android"){: .image-col-2}

Finally, I wanted to get really funky and fix back propagation to allow backward passes as well for the Caffe models in the browser. To show that BP is working, I ported the Deep [Dream demo from Google](https://github.com/google/deepdream) to JavaScript; here is a screenshot of Deep Dream running entirely in the browser using a pretrained GoogLeNet Caffe model. This demo also uses WebWorkers for performing the computation in a background thread.

![Deep Dream in JavaScript]({{ site.baseurl }}/images/projects/deepdream.png "Deep Dream in JavaScript"){: .image-col-1}

You can play around with GoogLeNet and all the demos directly in your browser on the [demos page][demo-caffejs] and find the [source on Github][github-caffejs].

[github-caffejs]: https://github.com/chaosmail/caffejs
[demo-caffejs]: https://chaosmail.github.io/caffejs/

## n3-line-charts - Awesome charts for Angular

2013 was the year of custom chart libraries, basically everyone ([including me](http://old.chaosmail.at/2013/angular-dchart/)) was building custom charting solutions based on RaphaelJS, plain SVG, D3.js or Canvas. Back then I realized that I don't want to put more effort into rebuilding existing functionality but rather contribute to an existing project. Therefore I looked around for the best charting library (for my needs) and got involved submitting PRs, fixing Issues and writing examples. This was the awesome library [n3-line-chart][github-n3charts]. I also realized, that it was tightly coupled to AngularJS which made it impossible to reuse it in different JS frameworks or simply VanillaJS. After some hangout discussions with the author [Sébastien Fragnaud](https://github.com/lorem--ipsum) we quickly decided to rewrite the whole library in TypeScript and decouple it from AngularJS. On top we introduced a modular event-based architecture allowing to extend the functionality of the library easily.

And here it is today, an awesome, clean and extensible charting library.

![n3-line-chart]({{ site.baseurl }}/images/projects/n3-line-chart.png "n3-line-chart"){: .image-col-1}

You can take a look at the charts on our [examples page][demo-n3charts].

[github-n3charts]: https://github.com/n3-charts/line-chart
[demo-n3charts]: http://n3-charts.github.io/line-chart/

## python-fs - A pythonic filesystem wrapper for humans

When dealing with typical filesystem operations in Python, I quickly found myself rewriting a lot of similar functionalities again and again for every project, such as finding files in folders, dumping objects to disk,  dealing with prefixes etc. On top I found it very hard to remember which functionalities can be found in which std libs, such as `os`, `os.path`, `shutil`, etc. Hence I decided to write a small library to wrap all filesystem operations in one place with a `bash` like API - this is what became `python-fs` in the end.

Installing is straight forward using pip.

`pip install pyfs`

Here is a simple example of using `python-fs` to delete all `*.pyc` files in the `src/` directory.

```python
import fs
fs.rm( fs.find('*.pyc', path='src') )
```

You can find extensive documentation and many examples on th [Github page of the project][github-pyfs].

[github-pyfs]: https://github.com/chaosmail/python-fs