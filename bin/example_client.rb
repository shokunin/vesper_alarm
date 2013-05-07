#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'uri'
require 'date'
require 'net/http'

# EXAMPLE nagios config in puppet
#  nagios_command { 'notify-service-by-vesper':
#    ensure       => present,
#    command_line => '$USER1$/post_alert.rb "HOSTALIAS=$HOSTALIAS$|HOSTGROUPNAMES=$HOSTGROUPNAMES$|HOSTSTATE=$HOSTSTATE$|SERVICEDISPLAYNAME=$SERVICEDISPLAYNAME$|SERVICESTATE=$SERVICESTATE$|SERVICEDESC=$SERVICEDESC$"',
#    target       => '/usr/local/icinga/etc/templates/commands.cfg',
#  }
#

HOST='http://localhost:4567/alert'
info = {}
begin
  ARGV[0].split('|').each do |z|
    k,v = z.split('=')
    if k == "HOSTGROUPNAMES"
      if v != nil
        info[k.downcase] = v.split(',')
      end
    else
      info[k.downcase] = v
    end
  end
    
  url = URI.parse(HOST)
  req = Net::HTTP::Post.new(url.path, initheader = {'Content-Type' =>'application/json'})
  req.body = info.to_json
  response = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
rescue Exception => e
  log = File.open('/var/tmp/alert.log', 'w')
  log.puts("#{Time.now} - ERROR: #{e.message} :: #{ARGV[0]}")
  log.close
end
