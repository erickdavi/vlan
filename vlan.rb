#!/usr/local/bin/ruby
require 'logger'
class Vlan
	attr_accessor :conf_file, :log_file
	def initialize(conf_file, log_file)
		@conf_file = conf_file
		@log_file = log_file
		if File.exist?(conf_file)
			@hashfile = []
			File.open(@conf_file, 'r') do |file|
				while line = file.gets
					colun = line.split(':')
					hashline = {vlan: colun[0], ip: colun[1], status: colun[2].chomp}
					@hashfile.push(hashline)
				end
			end
		else
			File.new(conf_file,"w+")
		end
		if !File.exist?(log_file)
			File.new(log_file,"w+")
		end
		@log = Logger.new(log_file)
	end
	def format_cachefile
		cachefile = ""
		@hashfile.each do |hashline|
			cachefile = cachefile + "#{hashline[:vlan]}:#{hashline[:ip]}:#{hashline[:status]}\n"
		end			
		return cachefile
	end	
	def test_ip(ip)
		indx = @hashfile.index do |hashline|
			hashline[:ip] == ip
		end
		if indx != nil
			out = {exists: true, status: @hashfile[indx][:status], indx: indx}
		else
			out = {exists: false, status: nil,indx: nil}
		end
	end
	def change_status(action, ip, email)
		ip_query = self.test_ip(ip)
		@stat = ip_query[:status]
		if ip_query[:exists] == true
			if @stat == "free" or @stat == "busy"
				case action
				when "use"
					@stat = "busy"
				when "vacate"
					@stat = "free"
				else
					out = "Invalid action #{action}"
				end
				if ip_query[:status] != @stat
					@hashfile[ip_query[:indx]][:status] = @stat
					File.new(@conf_file,'w').puts(format_cachefile)
					@log.info("#{ip} is #{@stat} now by #{email}")
					out = "#{ip} is #{@stat} now"
				else
					@log.error("Configuration not change - #{email}")
					out = "Configuration not change"
				end
			else
				@log.error("#{ip_query[:status]} is a invalid status")
				out = "#{ip_query[:status]} is a invalid status"
			end		
		else
			@log.error("#{ip} doesn't exists in configuration file")
			out = "#{ip} doesn't exists in configuration file"
		end
	end
	def newip(vlan, ip, email)
		ip_query = self.test_ip(ip)
		if !(ip_query[:exists]) and ((vlan.class != NilClass) and (ip.class != NilClass))
			line = "#{vlan}:#{ip}:free"
			File.new(@conf_file,'a').puts(line)
			@log.info("The ip address #{ip} of vlan #{vlan} were added in configuration file by #{email}")
			out = "The ip address #{ip} of vlan #{vlan} were added in configuration file"
		else
			@log.error("No change in configuration file")
			out = "No change in configuration file"
		end
	end
	def rmip(ip, email)
		ip_query = self.test_ip(ip)
		if ip_query[:exists] and @hashfile[ip_query[:indx]][:status] == "free"
			@hashfile.delete_at(ip_query[:indx])
			File.new(@conf_file,'w').puts(format_cachefile)
			@log.info("#{ip} removed by #{email}")
			out = "Done"
		elsif @hashfile[ip_query[:indx]][:status] == "busy"
			@log.error("This ip address is busy - #{email}")
			out = "This ip address is busy"
		else
			@log.error("Ip doesn't exists or their status is Invalid - #{email}")
			out = "Ip doesn't exists or their status is Invalid"
		end
	end
	def lsip()
		out = self.format_cachefile
	end		
end
