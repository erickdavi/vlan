#!/usr/bin/ruby

require './vlan.rb'

conf_file = "ddhcp.conf"

vl = Vlan.new(conf_file)

action = ARGV[0]
param1 = ARGV[1]
param2 = ARGV[2]
param3 = ARGV[3]
case action
when "request"
	response = vl.change_status(param1, param2)
	puts response
		
when "include"
	response = vl.newip(param1, param2)
	puts response

when "list"
	response = vl.list()
else 
	puts "Invalid parameter\nTry request, include or list"	
end