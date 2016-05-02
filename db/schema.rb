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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160502131002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "requests", force: :cascade do |t|
    t.string   "app",          null: false
    t.string   "logfile",      null: false
    t.string   "uuid",         null: false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "tester_bar"
  end

  add_index "requests", ["app"], name: "index_requests_on_app", using: :btree
  add_index "requests", ["completed_at"], name: "index_requests_on_completed_at", using: :btree
  add_index "requests", ["controller", "action"], name: "index_requests_on_controller_and_action", using: :btree
  add_index "requests", ["http_status"], name: "index_requests_on_http_status", using: :btree
  add_index "requests", ["logfile"], name: "index_requests_on_logfile", using: :btree
  add_index "requests", ["params"], name: "index_requests_on_params", using: :gin
  add_index "requests", ["subdomain"], name: "index_requests_on_subdomain", using: :btree
  add_index "requests", ["uuid"], name: "index_requests_on_uuid", unique: true, using: :btree

end
