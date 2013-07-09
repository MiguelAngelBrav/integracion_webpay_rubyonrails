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
		render :text => 'ACEPTADO', :layout => false
	end

	def root_path
	  Rails.root.join("vendor", "webpay").to_s
	end

	def payment_cgi_path
	  root_path + '/tbk_check_mac.cgi'
	end

  private


end