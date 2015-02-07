class ChangeRequestsParamsToJsonb < ActiveRecord::Migration
  def up
    execute "alter table requests alter column params type jsonb using params::jsonb"
  end

  def down
    execute "alter table requests alter column params type json using params::json"
  end
end
