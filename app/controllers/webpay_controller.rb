require 'net/http'
require 'cgi'

class WebpayController < ApplicationController

  VALID_MAC_RESPONSE = 'CORRECTO'
	
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
    
    result = valida_mac(ENV, request.raw_post)
    
    Rails.logger.debug "<<<<< result: #{result}"

    render :text => 'ACEPTADO', :layout => false
  end

  private
  
  def valida_mac(env, raw)
    body = ''

    file = Tempfile.new('webpay-mac-check', "#{root_path}/log/tmp/")
    file.write CGI.unescape(raw)
    file.rewind
    exe = "#{check_cgi_path} #{file.path}"

    Rails.logger.debug "<<<<< file.read: #{file.read}"

    stderr = Tempfile.new('webpay-cgi-stderr', "#{root_path}/log/tmp/")
    exec exe
    stderr.write(env['rack.input'].read) if env['rack.input']
    stderr.rewind
    body = stderr.read
    Rails.logger.debug "<<<<< body: #{body}"

    file.close!
    stderr.close!

    body
  end

  def root_path
    Rails.root.join("vendor", "webpay").to_s
  end
  
  def check_cgi_path
    root_path + '/tbk_check_mac.cgi'
  end


end