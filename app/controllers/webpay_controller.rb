class WebpayController < ApplicationController

	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		puts "\n***** success-env: #{env} *****\n"	
	end

	def failure
		puts "\n***** failure-env: #{env} *****\n"	
	end

	def check	
		puts "\n***** check-env: #{env} *****\n"	
	end
end
