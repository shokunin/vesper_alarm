#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', '..', 'conf', 'environment')
require 'unmatchedlistener'
require 'namedlistener'

module Vesper

  class Service

    def initialize 

      listeners     = []
      statements    = []
      notifications = []
      # Lets get the epService provider
      @ep_service = com.espertech.esper.client.EPServiceProviderManager.getDefaultProvider

      # And the configuration
      @ep_config = @ep_service.getEPAdministrator.getConfiguration

      ####################################################################################
      # Prepare the AlarmEvent type
      @order_event_type = {
        "host_name"     => "string",
        "alert_status"  => "string",
        "service_name"  => "string",
        "service_group" => "string",
      }
      @ep_config.addEventType("AlarmEvent", @order_event_type)

      ####################################################################################
      # Read the rules into the engine

      @@VCONF[:rules].each do |rule| 
        statement = @ep_service.getEPAdministrator.createEPL(rule[:statement])
        puts "adding RULE => #{rule[:statement]}"
        listeners << NamedListener.new(rule[:name], rule[:add_tags])
        statement.addListener(listeners[-1]);
      end

      ####################################################################################
      # Register unmatched listener
#      @unmatched_listener = UnmatchedListener.new
#      @ep_service.getEPRuntime.setUnmatchedListener(@unmatched_listener)
    end

    def process_event (alarm_event)
      #puts "received => #{alarm_event.inspect}"
      epr_runtime = @ep_service.getEPRuntime
      epr_runtime.sendEvent(alarm_event, "AlarmEvent")
    end

    def send_notification(notification_event)
      epr_runtime = @ep_service.getEPRuntime
      epr_runtime.sendEvent(notification_event, "NotificationEvent")
      puts "notification sent #{notification_event.inspect}"
    end

  end
end
