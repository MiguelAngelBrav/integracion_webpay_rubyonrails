require 'net/http'
require 'cgi'

class WebpayController < ApplicationController
	
	protect_from_forgery :except => [:success, :index, :failure, :check]

  def initialize
    
  end
	
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

    Rails.logger.debug "<<<<< comienza parseo"
    
    parse(ENV)
    
    Rails.logger.debug "<<<<< parametros parseados: #{raw}"

    Rails.logger.debug "<<<<< check-request"	


    render :text => 'ACEPTADO', :layout => false
  end

  private

  # Take the posted data and move the relevant data into a hash
  def parse(post)
    @raw = post
    for line in post.split('&')
      key, value = *line.scan( %r{^(\w+)\=(.*)$} ).flatten
      params[key] = value
    end
  end
  
  # def valid_mac
  #   if @valid_mac.nil?
  #     file = Tempfile.new 'webpay-mac-check'
  #     file.write raw
  #     file.close
  #     executable = Webpay.cgis_root + '/tbk_check_mac.cgi'
  #     @valid_mac = ( `#{executable} #{file.path}`.strip == VALID_MAC_RESPONSE )
  #     file.unlink
      
  #     fail! 'Mac Invalido' unless @valid_mac
  #   end
    
  #   @valid_mac
  # end

  def root_path
    Rails.root.join("vendor", "webpay").to_s
  end
  
  def check_cgi_path
    root_path + '/tbk_check_mac.cgi'
  end


end