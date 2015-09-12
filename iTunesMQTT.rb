#!/usr/bin/env ruby
require 'rubygems'
require 'mqtt'

SERVER = '192.168.8.2'
BASE = 'devlol/h19/tomk32/music'
VERSION = 0.3.1

MQTT::Client.connect(SERVER) do |c|
  c.publish(BASE + '/status', 'v%s active' % VERSION)
end

def itunes(message)
  message.gsub!(/[\\,;]/, '')
  message.gsub!(/'/, "\\'")
  puts "osascript -e 'tell application \"iTunes\"' -e '#{message}' -e 'end tell'"
  return `osascript -e 'tell application "iTunes"' -e '#{message}' -e 'end tell'`
end

def current_track
  artist = itunes("get artist of current track")
  track = itunes("get name of current track")
  return '%s - %s' % [artist, track]
end

# Check the current track every 5 seconds and publish a message if it has changed
Thread.new do
  last_track = nil
  while true do
    if last_track != (tmp = current_track())
      last_track = tmp
      MQTT::Client.connect(SERVER) do |c|
        c.publish(BASE + '/playing', last_track)
      end
    end
    sleep 5
  end
end

# Subscribe example
MQTT::Client.connect(SERVER) do |c|
  c.subscribe(%w(control play search current volume).collect{|t| [BASE, t].join('/')})
  c.get(BASE) do |topic, message|
    if topic.end_with?('/control')
      if %w(next previous).include?(message)
        itunes("%s track" % message)
      end
      if %w(toggle playpause).include?(message)
        itunes("playpause")
      end
      if %w(stop pause).include?(message)
        itunes(message)
      end
    end
    if topic.end_with?('/volume')
      volume = `osascript -e 'tell application "iTunes" to sound volume as integer'`.to_i
      if message == 'up'
        volume += 10
      elsif message == 'down'
        volume -= 10
      else
        volume = message
      end
      puts "Change volume to %i" % volume
      `osascript -e 'tell application "iTunes" to set sound volume to #{volume.to_i}'`
    end
    if topic.end_with?('/play')
      itunes('play track "%s"' % message)
    end
    if topic.end_with?('/current')
      c.publish(BASE + '/playing', current_track())
    end
  end
end
