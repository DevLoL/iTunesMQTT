A ruby script to control your mac's iTunes via [MQTT](http://mosquitto.org/). Your friends at the hackerspace will love it :)

## Installation:

iTunesMQTT has been developed on a recent OSX with ruby 2.2. Only library required is [`mqtt`](https://github.com/njh/ruby-mqtt) which you can install as follows:

    $ gem install mqtt

Copy iTunesMQTT.rb into you bin directory and run whenever you want to loose control over your iTunes.

You will have to change the `SERVER` and` BASE` variables in the ruby file to match your mqtt server.

Besides controls, it also output the trackinfo when a new song starts playing.

## Webinterface

This version also ships with a small webinterface for conveniently remote control your iTunes, which looks like [this](http://doebi.at/music)

## Commands supported

    BASE/control pause
    BASE/control toggle
    BASE/control next
    BASE/control previous

    BASE/volume up
    BASE/volume down
    BASE/volume 42

    BASE/play Title of a track

    BASE/current
      will send the current artist and track to BASE/playing

## Output only paths:

    BASE/playing
      output for /current and the automatic updater

    BASE/status
      outputs the version on startup

