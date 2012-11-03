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

ActiveRecord::Schema.define(:version => 20121103233530) do

  create_table "download_jobs", :force => true do |t|
    t.string   "title"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "directory"
    t.string   "url",             :limit => 1023
    t.integer  "subscription_id"
    t.integer  "user_id"
  end

  create_table "download_jobs_tags", :id => false, :force => true do |t|
    t.integer "download_job_id"
    t.integer "tag_id"
  end

  create_table "oauth2_authorizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth2_resource_owner_type"
    t.integer  "oauth2_resource_owner_id"
    t.integer  "client_id"
    t.string   "scope"
    t.string   "code",                       :limit => 40
    t.string   "access_token_hash",          :limit => 40
    t.string   "refresh_token_hash",         :limit => 40
    t.datetime "expires_at"
  end

  add_index "oauth2_authorizations", ["access_token_hash"], :name => "index_oauth2_authorizations_on_access_token_hash"
  add_index "oauth2_authorizations", ["client_id", "access_token_hash"], :name => "index_oauth2_authorizations_on_client_id_and_access_token_hash"
  add_index "oauth2_authorizations", ["client_id", "code"], :name => "index_oauth2_authorizations_on_client_id_and_code"
  add_index "oauth2_authorizations", ["client_id", "refresh_token_hash"], :name => "index_oauth2_authorizations_on_client_id_and_refresh_token_hash"

  create_table "oauth2_clients", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth2_client_owner_type"
    t.integer  "oauth2_client_owner_id"
    t.string   "name"
    t.string   "client_id"
    t.string   "client_secret_hash"
    t.string   "redirect_uri"
  end

  add_index "oauth2_clients", ["client_id"], :name => "index_oauth2_clients_on_client_id"

  create_table "resources", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "title"
    t.string   "destination"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_element"
    t.string   "extension"
    t.integer  "user_id"
  end

  add_index "subscriptions", ["resource_id"], :name => "index_subscriptions_on_resource_id"

  create_table "subscriptions_tags", :id => false, :force => true do |t|
    t.integer "subscription_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "show_source", :default => true
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "open_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
