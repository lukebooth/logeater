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
    
    class MalformedParameters < Error
      def initialize(input)
        super "Malformed parameters", input
      end
    end
    
    class ParserNotImplemented < Error
      def initialize(input)
        super "Unable to parse", input
      end
    end
  end
end
