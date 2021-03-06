module ETLTester

	module Util
		
		module DBConnection

			# Return a array of hash for the sql_txt.
			# You should install proper database driver.
			# e.g. if db_type is oracle, you should install dbi and ruby-oci8 first.
			def self.get_data_from_db db_type, config, sql_txt

				case type = db_type.downcase.to_sym
					when :oracle
						require 'dbi'
						begin
							dbh = DBI.connect("DBI:OCI8:#{config[:tns]}", config[:user_name], config[:password])
							rs = dbh.prepare sql_txt
							rs.execute
							records = []
							rs.fetch_all.each do |r| 
								record = r.to_h
								# Convert data type.
								record.each do |column_name, value|
									if value.class == BigDecimal
										if value.to_i == value
											record[column_name] = value.to_i
										end
									end
								end
								records << record
							end 

							records
						ensure
							dbh.disconnect unless dbh.nil?
						end
					else
						raise UnsupportError.new("Don't support #{type} so far.")
				end
						

			end
			
		end
		
		
	end
	
end