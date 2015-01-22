require "active_record"
require "activerecord-import"
require "activerecord-postgres-json"

module Logeater
  class Request < ActiveRecord::Base
    self.table_name = "requests"
    
    serialize :params, ActiveRecord::Coders::JSON
    
    
    
  end
end
