---
layout: post
title:  "Sound.io Introduction"
date:   2015-08-24 19:30:00
categories: web audio 
tags: soundio webaudio midi
comments: true
---

The [sound.io][soundio] library contains the graph object model - which uses the other libraries into it. So it helps us to construct the Audio graph out of a collection of [audio-objects][audio-object] and connections that links the audio-objects together. Article in progress..

## audio-object

[Audio object][audio-object] abstracts [Web Audio API][web-audio] and are the building blocks of an audio graph.

## soundio-object-template

The [soundio-object-template][soundio-object-template] contains a plugin template to build your own plugins. The *audio* variable in the constructor contains a reference to the [Audio Context][web-audio-audio-context].

## MIDI

[MIDI][midi] abstracts the Web MIDI API. It contains a *normalize* function that converts MIDI format to [Music JSON][music-json] which is used internally.

## Clock

Maps the web audio absolute time to a Clock time using rates.

## Sequence

Maps the clock time to the Sequence time.

### Sampler

```js
var soundio = Soundio();
var sampler = soundio.objects.create('sample');

// soundio.objects = [
//  {id; 0, type: 'sample'}
//]

sampler.trigger(0, 'noteon', 64, 127);
```

### Sample map

A [sample map][sample-map] maps notes across the keyboard and the velocity range.


## Music JSON

[Music JSON][music-json] is an interchangeable MIDI format of the web.

## Scribe

[Scribe][scribe] is a parser for [Music JSON][music-json] to create lead sheets in SVG.

## References:

* [sound.io][soundio]
* [soundio sample][sample]
* [soundio sample map][sample map]
* [sound.io object-template][soundio-object-template]
* [audio object][audio-object]
* [clock][clock]
* [MIDI][midi]
* [Scribe][scribe]
* [Web Audio API][web-audio]
* [Web Audio API - Audi Context][web-audio-audio-context]

[soundio]: https://github.com/soundio/soundio
[soundio-object-template]: https://github.com/soundio/soundio-object-template
[audio-object]: https://github.com/soundio/audio-object
[sample]: https://github.com/soundio/soundio/blob/master/js/soundio.sample.js#L435
[sample-map]: https://github.com/soundio/soundio/blob/master/js/soundio.sample.js#L12
[clock]: https://github.com/soundio/clock
[midi]: https://github.com/soundio/midi
[music-json]: https://github.com/soundio/music-json
[scribe]: https://github.com/soundio/scribe
[web-audio]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API
[web-audio-audio-context]: https://developer.mozilla.org/en-US/docs/Web/API/AudioContext