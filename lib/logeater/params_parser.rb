require "ripper"

module Logeater
  class ParamsParser
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def parse!
      identify tokenize_hash(clean(params))
    end

    def clean(params)
      loop do
        result = params.gsub(/\#<((?:[\w]|::)+):[^<>]+>/) { "\"#{$1}\"" }
        break if result == params
        params = result
      end
      params
    end

  private

    def tokenize_hash(ruby)
      sexp = Ripper.sexp(ruby)
      raise Parser::MalformedParameters.new(ruby) unless sexp

      # [:program, [[:hash, ... ]]]
      sexp[1][0]
    end

    def identify(sexp)
      case sexp[0]

      # [:string_literal, [:string_content, [:@tstring_content, "utf8", [1, 2]]]]
      # [:string_literal, [:string_content]]
      when :string_literal then sexp[1][1] ? sexp[1][1][1] : ""

      # [:@int, "10", [1, 14]]
      when :@int then sexp[1].to_i

      # [:@float, "10.56", [1, 14]]
      when :@float then sexp[1].to_f

      # [:unary, :-@, [:@float, \\\"173.41\\\", [1, 17285]]]
      when :unary then
        return -identify(sexp[2]) if sexp[1] == :-@
        raise Parser::ParserNotImplemented, "Unknown unary operator: #{sexp[1].inspect}"

      # [:var_ref, [:@kw, "true", [1, 12]]]
      when :var_ref then
        return true if sexp[1][1] == "true"
        return false if sexp[1][1] == "false"
        return nil if sexp[1][1] == "nil"
        raise Parser::ParserNotImplemented, "Unknown variable: #{sexp[1].inspect}"

      # [:array, [[:@int, "1", [1, 9]], [:@int, "4", [1, 12]]]]
      # [:array, nil]
      when :array then sexp[1] ? sexp[1].map { |sexp| identify(sexp) } : []

      #  [:hash,
      #    [:assoclist_from_args,
      #     [[:assoc_new,
      #       [:string_literal, [:string_content, [:@tstring_content, "utf8", [1, 2]]]],
      #       [:string_literal, [:string_content, [:@tstring_content, "✓", [1, 12]]]]]]]]]
      # [:hash, nil]
      when :hash then sexp[1] ? sexp[1][1].each_with_object({}) { |(_, key, value), hash| hash[identify(key)] = identify(value) } : {}

      else
        raise Parser::ParserNotImplemented, "I don't know how to identify #{sexp.inspect}"
        nil
      end
    rescue
      raise Parser::ParserNotImplemented, "An exception occurred when parsing #{sexp.inspect}\n#{$!.class.name}: #{$!.message}"
      nil
    end

  end
end
