#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'conf', 'environment')


require 'sinatra'
require 'vesper'
require 'json'
 

vesper_service = Vesper::Service.new

set :logging, false
set :dump_errors, false

post '/alert' do
  begin
    vesper_service.process_event(JSON.parse request.body.read.to_s)
  rescue Exception => e
    status 503
    {"error" => e.message}.to_json
  end
end
