class WebpayController < ApplicationController

	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		puts "\n***** success-request: #{request} *****\n"	
	end

	def failure
		puts "\n***** failure-request: #{request} *****\n"	
	end

	def check	
		puts "\n***** check-request: #{request} *****\n"	
	end
end
