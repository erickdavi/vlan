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
				
				#altera a linha para free

			elsif ip_data[:status] == 'free'

				#altera a linha para busy

			end
			#Com sorte reescreve o arquivo com a nova conf
			cache = format_cachefile
			file = File.new(@conf_file)
			file.puts(cache)

		else
			out = 'Configuration file error - BAD STATUS'
		end

	end	
	def get_hashfile
		return @hashfile
	end
end

vl = Vlan.new('ddhcp.conf')
