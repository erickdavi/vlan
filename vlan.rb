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

def set_ip(ip)
	indx = conf_load.index do |i|
		hashfile = i[:ip] == ip
	end

end
puts set_ip('10.1.10.51')