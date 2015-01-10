module Logeater
  class Parser
    
    class Error < ::ArgumentError
      def initialize(message, line)
        super "ERROR: #{message}\nDETAIL: #{line.inspect}"
      end
    end
    
    LINE_MATCHER = /^
      [A-Z],\s
    \[(?<timestamp>[^\s\]]+)(?:\s[^\]]*)?\]\s+
      (?<log_level>[A-Z]+)\s+\-\-\s:\s+
    \[(?<subdomain>[^\]]+)\]\s
    \[(?<uuid>[\w\-]{36})\]\s+
      (?<message>.*)
    $/x.freeze
    
    TIMESTAMP_MATCHER = /
      (?<year>\d\d\d\d)\-
      (?<month>\d\d)\-
      (?<day>\d\d)T
      (?<hours>\d\d):
      (?<minutes>\d\d):
      (?<seconds>\d\d(?:\.\d+))
    /x.freeze
    
    HTTP_VERBS = %w{DELETE GET HEAD OPTIONS PATCH POST PUT}.freeze
    
    
    def parse!(line)
      results = line.match(LINE_MATCHER)
      raise Error.new("Unmatched line", line) unless results
      
      timestamp = results["timestamp"]
      time = timestamp.match(TIMESTAMP_MATCHER)
      raise Error.new("Malformated timestamp", timestamp) unless time
      time = Time.new(*time.captures[0...-1], BigDecimal.new(time["seconds"]))
      
      type = identify_message(results["message"])
      
      { timestamp: time,
        log_level: results["log_level"],
        subdomain: results["subdomain"],
        uuid: results["uuid"],
        type: type,
        message: results["message"] }
    end
    
    def identify_message(message)
      return :request_started if message =~ /^Started (#{HTTP_VERBS.join("|")})/
      return :request_controller if message.start_with? "Processing by "
      return :request_params if message.start_with? "Parameters: "
      return :request_completed if message =~ /^Completed \d\d\d/
      :generic
    end
    
  end
end
