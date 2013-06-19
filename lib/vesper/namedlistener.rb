#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', '..', 'conf', 'environment')

module Vesper

  # Create a listener object
  class NamedListener
    include com.espertech.esper.client.UpdateListener
    attr_reader :name, :add_tags

    def initialize(name,add_tags)
      @name = name
      @add_tags = add_tags
    end

    def update(newEvents, oldEvents)
      newEvents.each do |event|
        puts "- " + event.getUnderlying.inspect
        puts "EFFYEAH: #{self.name} => #{self.add_tags.join ','}"
      end
    end
  end

end
