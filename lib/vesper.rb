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

require 'vesper/service'
require 'vesper/namedlistener'
require 'vesper/unmatchedlistener'

module Vesper

end
