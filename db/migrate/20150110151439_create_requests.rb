class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :app, null: false
      t.string :logfile, null: false
      
      t.string :uuid, null: false
      t.string :subdomain
      t.timestamp :started_at
      t.timestamp :completed_at
      t.integer :duration
      t.string :http_method
      t.string :path
      t.text :params
      t.string :controller
      t.string :action
      t.string :remote_ip
      t.string :format
      t.integer :http_status
      t.string :http_response
      
      t.timestamps
    end
    
    add_index :requests, :app
    add_index :requests, :logfile
    add_index :requests, :uuid, unique: true
    add_index :requests, [:controller, :action]
    add_index :requests, :http_status
  end
end
