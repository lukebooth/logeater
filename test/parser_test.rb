require "test_helper"

class ParserTest < ActiveSupport::TestCase
  attr_reader :line
  
  
  
  context "given any line, it" do
    setup do
      @line = "I, [2015-01-10T15:18:05.850839 #18070]  INFO -- : [livingsaviorco] [2d89d962-57c4-47c9-a9e9-6a16a5f22a12] [gzip] Compress reponse by 42.2 KB (83.3%)  (1.4ms)"
    end
    
    should "identify the log level" do
      assert_parses log_level: "INFO"
    end
    
    should "identify the time, including milliseconds" do
      assert_parses timestamp: Time.new(2015, 1, 10, 15, 18, BigDecimal.new("5.850839"))
    end
    
    should "identify the subdomain" do
      assert_parses subdomain: "livingsaviorco"
    end
    
    should "identify the request's ID" do
      assert_parses uuid: "2d89d962-57c4-47c9-a9e9-6a16a5f22a12"
    end
  end
  
  
  
  context "given a generic line, it" do
    setup do
      @line = "I, [2015-01-10T15:18:05.850839 #18070]  INFO -- : [livingsaviorco] [2d89d962-57c4-47c9-a9e9-6a16a5f22a12] [gzip] Compress reponse by 42.2 KB (83.3%)  (1.4ms)"
    end
    
    should "identify the line as :generic" do
      assert_parses type: :generic
    end
    
    should "identify the remainder of the log message" do
      assert_parses message: "[gzip] Compress reponse by 42.2 KB (83.3%)  (1.4ms)"
    end
  end
  
  
  
private
  
  def assert_parses(expectations)
    results = parser.parse!(line)
    
    expectations.each do |key, value|
      assert_equal value, results[key]
    end
  end
  
  def parser
    Logeater::Parser.new
  end
  
end
