require "active_record"

module Logeater
  class Event < ActiveRecord::Base
    self.table_name = "events"

    def self.since(timestamp)
      self
    end
  end
end
