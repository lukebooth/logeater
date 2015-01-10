require "test_helper"

class LogeaterTest < ActiveSupport::TestCase
  attr_reader :logfile
  
  
  context "Given the log of a single request, it" do
    setup do
      @logfile = File.expand_path("../../data/single_request.log", __FILE__)
    end
    
    should "identify the name of the logfile" do
      assert_equal "single_request.log", reader.filename
    end
    
    should "create an entry in the database" do
      assert_difference "Logeater::Request.count", +1 do
        reader.import
      end
    end
    
    should "set all the attributes" do
      reader.import
      request = Logeater::Request.first
      
      params = {"refresh_page" => "true", "id" => "1035826228"}
      assert_equal "test", request.app
      assert_equal "single_request.log", request.logfile
      assert_equal "0fc5154a-c288-4bad-9c7a-de3d7e7d2496", request.uuid
      assert_equal "livingsaviorco", request.subdomain
      assert_equal Time.new(2015, 1, 10, 15, 18, BigDecimal.new("12.064392")), request.started_at
      assert_equal Time.new(2015, 1, 10, 15, 18, BigDecimal.new("12.262903")), request.completed_at
      assert_equal 196, request.duration
      assert_equal "GET", request.http_method
      assert_equal "/people/1035826228", request.path
      assert_equal params, request.params
      assert_equal "people_controller", request.controller
      assert_equal "show", request.action
      assert_equal "71.218.222.249", request.remote_ip
      assert_equal "JS", request.format
      assert_equal 200, request.http_status
      assert_equal "OK", request.http_response
    end
    
    should "erase any entries that had already been imported with that app and filename" do
      Logeater::Request.create!(app: app, logfile: "single_request.log", uuid: "1")
      Logeater::Request.create!(app: app, logfile: "single_request.log", uuid: "2")
      Logeater::Request.create!(app: app, logfile: "single_request.log", uuid: "3")
      
      assert_difference "Logeater::Request.count", -2 do
        reader.import
      end
    end
  end
  
  
  context "Given a gzipped logfile, it" do
    setup do
      @logfile = File.expand_path("../../data/single_request.gz", __FILE__)
    end
    
    should "create an entry in the database" do
      assert_difference "Logeater::Request.count", +1 do
        reader.import
      end
    end
  end
  
  
private
  
  def app
    "test"
  end
  
  def reader
    Logeater::Reader.new(app, logfile)
  end
  
end
