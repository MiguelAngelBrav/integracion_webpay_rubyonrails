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
		run(env, payment_cgi_path)
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

  # Extracted from rack-legacy
  def run(env, *path)
    status = 200
    headers = {}
    body = ''

    Rails.logger.debug "\n***** Rails.root: #{Rails.root} *****\n"  

    stderr = Tempfile.new 'legacy-rack-stderr'
    IO.popen('-', 'r+') do |io|
      if io.nil?  # Child
        $stderr.reopen stderr.path
        ENV['DOCUMENT_ROOT'] = Rails.root
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



end