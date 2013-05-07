#!/usr/bin/env ruby

require 'yaml'

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
$CLASSPATH << File.join(File.dirname(__FILE__), "..", "lib")

@@VCONF = YAML::load(File.open(File.join(File.dirname(__FILE__), "vesper.conf")))

