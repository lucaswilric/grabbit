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

ActiveRecord::Schema.define(:version => 20130106014703) do

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

  add_index "download_jobs_tags", ["tag_id", "download_job_id"], :name => "index_download_jobs_tags_on_tag_id_and_download_job_id"

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
