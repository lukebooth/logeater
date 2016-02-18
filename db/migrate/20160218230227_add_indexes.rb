class AddIndexes < ActiveRecord::Migration
  def change
    add_index :requests, :completed_at
    add_index :requests, :subdomain
    add_index :requests, :params, using: :gin
  end
end
