module Logeater
  class Parser
    
    class Error < ::ArgumentError
      def initialize(message, input)
        super "#{message}: #{input.inspect}"
      end
    end
    
    class UnmatchedLine < Error
      def initialize(input)
        super "Unmatched line", input
      end
    end
    
    class MalformedTimestamp < Error
      def initialize(input)
        super "Malformed timestamp", input
      end
    end
  end
end
