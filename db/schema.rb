# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150224021844) do

  create_table "requests", :force => true do |t|
    t.string   "app",           :null => false
    t.string   "logfile",       :null => false
    t.string   "uuid",          :null => false
    t.string   "subdomain"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "duration"
    t.string   "http_method"
    t.text     "path"
    t.jsonb    "params"
    t.string   "controller"
    t.string   "action"
    t.string   "remote_ip"
    t.string   "format"
    t.integer  "http_status"
    t.string   "http_response"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "requests", ["app"], :name => "index_requests_on_app"
  add_index "requests", ["controller", "action"], :name => "index_requests_on_controller_and_action"
  add_index "requests", ["http_status"], :name => "index_requests_on_http_status"
  add_index "requests", ["logfile"], :name => "index_requests_on_logfile"
  add_index "requests", ["uuid"], :name => "index_requests_on_uuid", :unique => true

end
