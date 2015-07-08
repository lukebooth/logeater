require "logeater/request"
require "zlib"
require "ruby-progressbar"
require "oj"

module Logeater
  class Reader
    attr_reader :app, :path, :filename, :batch_size
    
    def initialize(app, path, options={})
      @app = app
      @path = path
      @filename = File.basename(path)
      @parser = Logeater::Parser.new
      @show_progress = options.fetch :progress, false
      @batch_size = options.fetch :batch_size, 500
      @verbose = options.fetch :verbose, false
      @requests = {}
      @completed_requests = []
    end
    
    
    
    def reimport
      remove_existing_entries!
      import
    end
    
    def import
      each_request do |attributes|
        completed_requests.push Logeater::Request.new(attributes)
        save! if completed_requests.length >= batch_size
      end
      save!
    end
    
    def parse(to: $stdout)
      to << "["
      first = true
      each_request do |attributes|
        if first
          first = false
        else
          to << ",\n"
        end

        to << Oj.dump(attributes, mode: :compat)
      end
    ensure
      to << "]"
    end
    
    def remove_existing_entries!
      Logeater::Request.where(app: app, logfile: filename).delete_all
    end
    
    def show_progress?
      @show_progress
    end
    
    def verbose?
      @verbose
    end
    
    def each_line
      File.open(path) do |file|
        io = File.extname(path) == ".gz" ? Zlib::GzipReader.new(file) : file
        pbar = ProgressBar.create(title: filename, total: file.size, autofinish: false, output: $stderr) if show_progress?
        io.each_line do |line|
          yield line
          pbar.progress = file.pos if show_progress?
        end
        pbar.finish if show_progress?
      end
    end
    alias :scan :each_line
    
    def each_request
      count = 0
      each_line do |line|
        process_line! line do |request|
          yield request
          count += 1
        end
      end
      count
    end
    
    
    
  private
    attr_reader :parser, :requests, :completed_requests
    
    def process_line!(line, &block)
      attributes = parser.parse!(line)
      
      return if [:generic, :request_line].member? attributes[:type]
      
      if attributes[:type] == :request_started
        requests[attributes[:uuid]] = attributes
          .slice(:uuid, :subdomain, :http_method, :path, :remote_ip, :user_id, :tester_bar)
          .merge(started_at: attributes[:timestamp], logfile: filename, app: app)
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
        
        yield request_attributes
        requests.delete attributes[:uuid]
      end
      
    rescue Logeater::Parser::UnmatchedLine
      $stderr.puts "\e[90m#{$!.message}\e[0m" if verbose?
    rescue Logeater::Parser::Error
      log $!.message
    end
    
    def save!
      return if completed_requests.empty?
      Logeater::Request.import(completed_requests)
      completed_requests.clear
    end
    
    
    
    def log(statement)
      $stderr.puts "\e[33m#{statement}\e[0m"
    end
    
  end
end
