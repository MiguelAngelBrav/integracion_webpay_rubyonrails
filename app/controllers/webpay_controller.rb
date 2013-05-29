class WebpayController < ApplicationController
	
	 protect_from_forgery :except => [:success, :index, :failure, :check]
	
	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		Rails.logger.debug "\n***** success-request: #{request.inspect} *****\n"	
	end

	def failure
		Rails.logger.debug "\n***** failure-request: #{request.inspect} *****\n"	
	end

	def check	
		Rails.logger.debug "\n***** check-request: #{request.inspect} *****\n"	
	end
end
