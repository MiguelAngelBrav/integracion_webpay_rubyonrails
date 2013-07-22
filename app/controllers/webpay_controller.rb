require 'net/http'
require 'cgi'

class WebpayController < ApplicationController
	
	protect_from_forgery :except => [:success, :index, :failure, :check]
	
	def index
		require 'date'
		@oc = "OC_" + Time.now.strftime("%Y%m%d%H%M%S")
		@mount = 10000
	end

	def success
		Rails.logger.debug "\n<<<<< success-request \n" 
	end

	def failure
		Rails.logger.debug "\n<<<<< failure-request \n" 
	end

	def check

    result = system("./" + Rails.root.join("vendor", "webpay").to_s + "/tbk_check_mac.cgi")

    # se carga la respueta en body
    body = result

    Rails.logger.debug "<<<<< request-to: ./" + Rails.root.join("vendor", "webpay").to_s + "/tbk_check_mac.cgi"

    Rails.logger.debug "<<<<< body: #{body}"

    Rails.logger.debug "\n<<<<< check-request \n"	
    render :text => 'ACEPTADO', :layout => false
  end


  private


end