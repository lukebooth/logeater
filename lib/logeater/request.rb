require "active_record"

module Logeater
  class Request < ActiveRecord::Base
    self.table_name = "requests"
    
    serialize :params, JSON
    
    
    
  end
end
