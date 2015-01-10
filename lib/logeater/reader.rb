require "logeater/request"

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
    
    
    def import
      File.open(path).each do |line|
        attributes = parser.parse!(line)
        
        if attributes[:type] == :request_started
          requests[attributes[:uuid]] = attributes
            .slice(:uuid, :subdomain, :http_method, :path, :remote_ip)
            .merge(started_at: attributes[:timestamp])
        else
          request_attributes = requests[attributes[:uuid]]
          if request_attributes
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
          else
            log "Attempting to record #{attributes[:type].inspect}; but there is no request started with UUID #{attributes[:uuid].inspect}"
          end
        end
      end
    end
    
    
  private
    attr_reader :parser, :requests
    
    def save!(attributes)
      Logeater::Request.create!(attributes.merge(app: app, logfile: filename))
    end
    
  end
end
