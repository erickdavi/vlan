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
		end
	end		
	def change_status(action, ip)
		ip_query = self.test_ip(ip)
		@stat = ip_query[:status]
		if ip_query[:exists] == true
			if @stat == "free" or @stat	== "busy"
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
					out = "#{ip} is #{@stat} now"
				else
					out = "Configuration not change"					
				end
			else
				out = "#{ip_query[:status]} is a invalid status"
			end		
		else
			out = "#{ip} doesn't exists in configuration file"
		end
	end

	def newip(vlan, ip)
		ip_query = self.test_ip(ip)
		if !(ip_query[:exists]) and ((vlan.class != NilClass) and (ip.class != NilClass))
			line = "#{vlan}:#{ip}:free"
			File.new(@conf_file,'a').puts(line)
			out = "The ip address #{ip} of vlan #{vlan} were added in configuration file"
		else
			out = "No change in configuration file"
		end
	end
end