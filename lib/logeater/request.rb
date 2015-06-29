require "active_record"
require "activerecord-import"

module Logeater
  class Request < ActiveRecord::Base
    self.table_name = "requests"

  end
end
