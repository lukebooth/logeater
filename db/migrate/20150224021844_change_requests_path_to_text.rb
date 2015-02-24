class ChangeRequestsPathToText < ActiveRecord::Migration
  def up
    execute "alter table requests alter column path type text"
  end

  def down
    execute "alter table requests alter column path type varchar"
  end
end
