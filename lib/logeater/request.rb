require "active_record"
require "activerecord-import"

module Logeater
  class Request < ActiveRecord::Base
    self.table_name = "requests"

    def self.import(values)
      # values have to be unique by uuid
      values = values.uniq { |request| request.uuid }

      super values
    rescue PG::UniqueViolation, ActiveRecord::RecordNotUnique
      # try again after skipping requests with existing uuids
      existing_uuids = where(uuid: values.map(&:uuid)).pluck(:uuid)
      values = values.reject { |request| existing_uuids.member?(request.uuid) }

      super values
    end

  end
end
