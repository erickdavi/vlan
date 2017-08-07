class Vlan

	def conf_load
		conf_file = 'ddhcp.conf'
		cachefile = []
		File.open(conf_file, 'r') do |file|
			while line = file.gets
				colun = line.split(':')
				hashfile = {vlan: colun[0], ip: colun[1], status: colun[2].chomp}
				cachefile.push(hashfile)
			end
		end
		return cachefile
	end	

	def test_ip(ip)
		indx = self.conf_load.index do |hashfile|
			hashfile[:ip] == ip
		end
		if indx == nil
			out = [false,nil,nil]
		else
			hashline = self.conf_load[indx]
			out = [true,hashline,indx]
		end			
	end
	def format_cachefile(hashfile)
		cachefile = ""
		hashfile.each do |hashline|
			cachefile = cachefile + "#{hashline[:vlan]}:#{hashline[:ip]}:#{hashline[:status]}\n"
		end			
		return cachefile
	end		

	def get_ip(ip)
		hashfile = self.conf_load
		mtrx_status = test_ip(ip)
		hashline = mtrx_status[1]
		indx = mtrx_status[2]
		
		if mtrx_status[0]
			if hashline[:status] == 'free'
				hashline[:status] = 'busy'
				hashfile[indx] = hashline
				#cachefile = self.format_cachefile(hashline)
			elsif hashline[:status] == 'busy'

			else 
				out = 'Conf file error'
			end
		else
			out = 'Ip does not exist in configuration file'		
		end
	end		

end

a = Vlan.new
cache = a.get_ip('10.1.10.52')

b = a.format_cachefile(cache)
puts b

#puts a.set_ip('10.1.10.50','erickdavi@gmail.com')
#puts a.set_ip('10.1.10.53','erickdavi@gmail.com')
=begin
def set_ip(ip,email)
		ip_status = self.has_ip?(ip)
		if ip_status
			indx = self.conf_load.index do |hashfile|
				hashfile[:ip] == ip
			end			
			hashline = self.conf_load[indx]
			puts hashline
		else
			
		end
	end	



def show(flag1, vlan)
	if vlan == nil
		case flag1
		when 'conf'
			out = ''
			conf_load.each do |indx|
				out = out +"#{indx[:vlan]}:#{indx[:ip]}:#{indx[:status]}\n"
			end

		when 'free'
			out = "Free IPs:\n"
			conf_load.each do |indx|
				if indx[:status] == 'free'
					out = out + "#{indx[:vlan]}:#{indx[:ip]}\n"
				end
			end
		when 'busy'
			out = "Busy IPs:\n"
			conf_load.each do |indx|
				if indx[:status] == 'busy'
					out = out + "#{indx[:vlan]}:#{indx[:ip]}\n"
				end
			end
		else
			out = 'Invalid option'			
		end		
	elsif flag1 == 'vlan' and vlan != nil
		out = "Vlan #{vlan}:\n"
			conf_load.each do |indx|
				if indx[:vlan] == vlan
					out = out + "#{indx[:ip]} -> status[#{indx[:status]}]\n"
				else
					out = "#{out.chomp} vlan nonexistent\n"
					break
				end
			end	
	end
	return out
end
=end
