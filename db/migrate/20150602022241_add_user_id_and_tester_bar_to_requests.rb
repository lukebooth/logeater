class AddUserIdAndTesterBarToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :user_id, :integer
    add_column :requests, :tester_bar, :boolean
  end
end
