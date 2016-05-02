class DropHttpResponse < ActiveRecord::Migration
  def up
    remove_column :requests, :http_response
  end

  def down
    add_column :requests, :http_response, :string
  end
end
