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

    Rails.logger.debug "<<<<< env: #{ENV.inspect}"
    Rails.logger.debug "<<<<< check_cgi_path: #{check_cgi_path}"
  
    result = exec_cgi(ENV, check_cgi_path)

    Rails.logger.debug "<<<<< result: #{result}"

    Rails.logger.debug "\n<<<<< check-request \n"	
    render :text => 'ACEPTADO', :layout => false
  end

  protected

  # Extracted from rack-legacy
  def exec_cgi(env,cgi_path)
    status = 200
    headers = {}
    body = ''

    stderr = Tempfile.new 'webpay-cgi-stderr'
    IO.popen('-', 'r+') do |io|
      if io.nil?  # Child
        $stderr.reopen stderr.path
        ENV['DOCUMENT_ROOT'] = root_path
        ENV['SERVER_SOFTWARE'] = 'Rack Legacy'
        env.each {|k, v| ENV[k] = v if v.respond_to? :to_str}
        exec *path
      else        # Parent
        io.write(env['rack.input'].read) if env['rack.input']
        io.close_write
        until io.eof? || (line = io.readline.chomp) == ''
          if line =~ /\s*\:\s*/
            key, value = line.split(/\s*\:\s*/, 2)
            if headers.has_key? key
              headers[key] += "\n" + value
            else
              headers[key] = value
            end
          end
        end
        body = io.read
        stderr.rewind
        stderr = stderr.read
        Process.wait
        unless $?.exitstatus == 0
          status = 500
          body = ErrorPage.new(env, headers, body, stderr).to_s
          headers = {'Content-Type' => 'text/html'}
        end
      end
    end

    status = headers.delete('Status').to_i if headers.has_key? 'Status'
    [status, headers, [body]]
  end

  def root_path
    Rails.root.join("vendor", "webpay").to_s
  end
  
  def check_cgi_path
    root_path + '/tbk_check_mac.cgi'
  end


end