require "logeater/request"
require "zlib"

module Logeater
  class Reader
    attr_reader :app, :path, :filename
    
    def initialize(app, path)
      @app = app
      @path = path
      @filename = File.basename(path)
      @parser = Logeater::Parser.new
      @requests = {}
    end
    
    
    
    def reimport
      remove_existing_entries!
      import
    end
      
    def import
      each_line(&method(:process_line!))
    end
    
    def remove_existing_entries!
      Logeater::Request.where(app: app, logfile: filename).delete_all
    end
    
    
  private
    attr_reader :parser, :requests, :completed_requests
    
    def process_line!(line)
      attributes = parser.parse!(line)
      
      return if attributes[:type] == :generic
      
      if attributes[:type] == :request_started
        requests[attributes[:uuid]] = attributes
          .slice(:uuid, :subdomain, :http_method, :path, :remote_ip)
          .merge(started_at: attributes[:timestamp])
        return
      end
      
      request_attributes = requests[attributes[:uuid]]
      unless request_attributes
        log "Attempting to record #{attributes[:type].inspect}; but there is no request started with UUID #{attributes[:uuid].inspect}"
        return
      end
      
      case attributes[:type]
      when :request_controller
        request_attributes.merge! attributes.slice(:controller, :action, :format)
      
      when :request_params
        request_attributes.merge! attributes.slice(:params)
      
      when :request_completed
        request_attributes.merge! attributes
          .slice(:http_status, :http_response, :duration)
          .merge(completed_at: attributes[:timestamp])
        
        save! requests.delete(attributes[:uuid])
      end
      
    rescue Logeater::Parser::Error
      log $!.message
    end
    
    def each_line(&block)
      file = File.extname(path) == ".gz" ? Zlib::GzipReader.open(path) : File.open(path)
      file.each_line(&block)
    ensure
      file.close
    end
    
    def save!(attributes)
      Logeater::Request.create!(attributes.merge(app: app, logfile: filename))
    end
    
    
    
    def log(statement)
      puts "\e[33m#{statement}\e[0m"
    end
    
  end
end
