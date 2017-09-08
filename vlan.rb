#!/usr/local/bin/ruby
class Vlan
	attr_accessor :conf_file
	def initialize(conf_file)
		@conf_file = conf_file
		@hashfile = []
		File.open(@conf_file, 'r') do |file|
			while line = file.gets
				colun = line.split(':')
				hashline = {vlan: colun[0], ip: colun[1], status: colun[2].chomp}
				@hashfile.push(hashline)
			end
		end
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
	def change_status(ip)
		ip_data = self.test_ip(ip)
		if ip_data[:exists] and ip_data[:status] == 'busy' or ip_data[:status] == 'free'
			if ip_data[:status] == 'busy'
				puts "This ip address is already busy"
				puts "Do you want to use it anyway?"
				puts "y/n"
				response = gets
				if response.chomp.capitalize == "Y"
					puts response
					@hashfile[ip_data[:indx]][:status] = 'free'
				end									
			elsif ip_data[:status] == 'free'
				@hashfile[ip_data[:indx]][:status] = 'busy'
			end
			File.new(@conf_file,'w').puts(format_cachefile)
			out = "#{@hashfile[ip_data[:indx]][:ip]} is #{@hashfile[ip_data[:indx]][:status]} now"
		else
			out = 'Configuration file error - BAD STATUS'
		end
	end	

	def newip(vlan, ip)
		ip_query = self.test_ip(ip)
		if !(ip_query[:exists])
			line = "#{vlan}:#{ip}:free"
			File.new(@conf_file,'a').puts(line)
			out = true
		else
			out = false	
		end
	end
end