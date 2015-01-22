class ChangeRequestsParamsToJson < ActiveRecord::Migration
  def up
    execute "alter table requests alter column params type json using params::json"
  end

  def down
    change_column :requests, :params, :text
  end
end
