#!/usr/bin/env ruby

require 'java'
require 'pp'
require File.join(File.dirname(__FILE__), '..', 'conf', 'environment')


require 'java/esper-4.8.0/esper-4.8.0.jar'
require 'java/esper-4.8.0/esper/lib/commons-logging-1.1.1.jar'
require 'java/esper-4.8.0/esper/lib/antlr-runtime-3.2.jar'
require 'java/esper-4.8.0/esper/lib/cglib-nodep-2.2.jar'
require 'java/esper-4.8.0/esper/lib/log4j-1.2.16.jar'
java_import 'com.espertech.esper.client.EPRuntime'
java_import 'com.espertech.esper.client.EPServiceProviderManager'
java_import 'com.espertech.esper.client.EPServiceProvider'
java_import 'com.espertech.esper.client.EPStatement'
java_import 'com.espertech.esper.client.UpdateListener'
java_import 'com.espertech.esper.client.EventBean'
java_import 'org.apache.commons.logging.Log'
java_import 'org.apache.commons.logging.LogFactory'
java_import 'AlertEvent'

module Vesper

  class Service

    def initialize 

      listeners  = []
      statements = []
      # Lets get the epService provider
      @ep_service = com.espertech.esper.client.EPServiceProviderManager.getDefaultProvider

      # And the configuration
      @ep_config = @ep_service.getEPAdministrator.getConfiguration

      # Prepare the AlarmEvent type
      @order_event_type = {
        "host_name"     => "string",
        "alert_status"  => "string",
        "service_name"  => "string",
        "service_group" => "string",
      }
      @ep_config.addEventType("AlarmEvent", @order_event_type)

      @@VCONF[:rules].each do |rule| 
        statement = @ep_service.getEPAdministrator.createEPL(rule[:statement])
        puts "adding RULE => #{rule[:statement]}"
        listeners << NamedListener.new(rule[:name], rule[:add_tags])
        statement.addListener(listeners[-1]);
      end

      # Register unmatched listener
      @unmatched_listener = MyUnmatchedListener.new
      @ep_service.getEPRuntime.setUnmatchedListener(@unmatched_listener)
    end

    def process_event (alarm_event)
      #puts "received => #{alarm_event.inspect}"
      epr_runtime = @ep_service.getEPRuntime
      epr_runtime.sendEvent(alarm_event, "AlarmEvent")
    end
  end

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

  # Create an unmatched listener
  class MyUnmatchedListener
    include com.espertech.esper.client.UnmatchedListener

    def update(event)
      puts "unmatched_event: " + event.getProperties.inspect
    end
  end

end
