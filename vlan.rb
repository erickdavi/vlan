class Vlan
	protected def conf_load
		conf_file = 'ddhcp.conf'
		hashfile = []
		File.open(conf_file, 'r') do |file|
			while line = file.gets
				colun = line.split(':')
				hashline = {vlan: colun[0], ip: colun[1], status: colun[2].chomp}
				hashfile.push(hashline)
			end
		end
		return hashline
	end	
	protected def test_ip(ip)
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
	protected def format_cachefile(hashfile)
		cachefile = ""
		hashfile.each do |hashline|
			cachefile = cachefile + "#{hashline[:vlan]}:#{hashline[:ip]}:#{hashline[:status]}\n"
		end			
		return cachefile
	end	

	protected def get_ip(ip)
		hashfile = self.conf_load
		mtrx_status = test_ip(ip)
		hashline = mtrx_status[1]
		indx = mtrx_status[2]
		if mtrx_status[0]
			if hashline[:status] == 'free'
				hashline[:status] = 'busy'
				hashfile[indx] = hashline
				cachefile = self.format_cachefile(hashfile)	
				conffile = File.new('ddhcp.conf','w')
				conffile.puts(cachefile)
				conffile.close
				#log_entrie = "#{email} are using #{ip} "
			elsif hashline[:status] == 'busy'
				out = 'No change has done'
			else 
				out = 'Configuration file error'
			end
		else
			out = 'Ip does not exist in configuration file'		
		end
	end		
end
