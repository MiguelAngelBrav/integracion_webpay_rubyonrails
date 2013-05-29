class WebpayController < ApplicationController

	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		Rails.logger.debug "\n***** success-request: #{request} *****\n"	
	end

	def failure
		Rails.logger.debug "\n***** failure-request: #{request} *****\n"	
	end

	def check	
		Rails.logger.debug "\n***** check-request: #{request} *****\n"	
	end
end
