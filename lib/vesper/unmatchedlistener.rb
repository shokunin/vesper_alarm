#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', '..', 'conf', 'environment')

module Vesper

  # Create an unmatched listener
  class UnmatchedListener
    include com.espertech.esper.client.UnmatchedListener

    def update(event)
      puts "unmatched_event: " + event.getProperties.inspect
    end
  end

end
