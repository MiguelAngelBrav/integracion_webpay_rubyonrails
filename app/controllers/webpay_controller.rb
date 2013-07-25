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
    cgi_to_exec = "#{check_cgi_path} #{file.path}"

    body = ''

    stderr = Tempfile.new 'webpay-cgi-stderr'
    IO.popen('-', 'r+') do |io|
      if io.nil?  # Child
        $stderr.reopen stderr.path
        ENV['DOCUMENT_ROOT'] = root_path
        env.each {|k, v| ENV[k] = v if v.respond_to? :to_str}

        exec ENV, cgi_to_exec
      else        # Parent
        io.write(env['rack.input'].read) if env['rack.input']
        io.close_write
        body = io.read
        stderr.rewind
        stderr = stderr.read
        Process.wait
        unless $?.exitstatus == 0
          body = 'INVALIDO'
        end
      end
    end

    body
  end

  def root_path
    Rails.root.join("vendor", "webpay").to_s
  end
  
  def check_cgi_path
    root_path + '/tbk_check_mac.cgi'
  end


end