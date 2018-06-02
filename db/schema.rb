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

ActiveRecord::Schema.define(version: 20170531004543) do

  create_table "activity_logs", force: :cascade do |t|
    t.string   "activity",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.string   "title",            limit: 255
    t.string   "email",            limit: 255
    t.string   "password_hash",    limit: 255
    t.string   "password_salt",    limit: 255
    t.string   "apikey",           limit: 255
    t.string   "password_recover", limit: 255
    t.string   "status",           limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "citizen_requests", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "department_id",      limit: 4
    t.integer  "citizen_request_id", limit: 4
    t.string   "title",              limit: 255
    t.text     "request",            limit: 65535
    t.string   "status",             limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "description",              limit: 255
    t.text     "body",                     limit: 65535
    t.string   "status",                   limit: 255
    t.string   "sort_order",               limit: 255
    t.string   "url_slug",                 limit: 255
    t.integer  "admin_id",                 limit: 4
    t.string   "apikey",                   limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size",    limit: 4
    t.datetime "cover_image_updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.string   "file_type",   limit: 255
    t.string   "file_url",    limit: 255
    t.integer  "admin_id",    limit: 4
    t.string   "apikey",      limit: 255
    t.integer  "sort_order",  limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "email",               limit: 255
    t.string   "password_hash",       limit: 255
    t.string   "password_salt",       limit: 255
    t.string   "apikey",              limit: 255
    t.string   "password_recover",    limit: 255
    t.string   "status",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.string   "description",              limit: 255
    t.datetime "start_time"
    t.string   "status",                   limit: 255
    t.integer  "admin_id",                 limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size",    limit: 4
    t.datetime "cover_image_updated_at"
    t.datetime "end_time"
    t.string   "apikey",                   limit: 255
    t.string   "url_slug",                 limit: 255
  end

  add_index "events", ["admin_id"], name: "index_events_on_admin_id", using: :btree
  add_index "events", ["apikey"], name: "index_events_on_apikey", using: :btree
  add_index "events", ["end_time"], name: "index_events_on_end_time", using: :btree
  add_index "events", ["start_time"], name: "index_events_on_start_time", using: :btree
  add_index "events", ["status"], name: "index_events_on_status", using: :btree

  create_table "gallery_categories", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "admin_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "gallery_items", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.string   "status",             limit: 255
    t.integer  "admin_id",           limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "content",            limit: 65535
    t.integer  "admin_id",           limit: 4
    t.string   "apikey",             limit: 255
    t.string   "url_slug",           limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "page_categories", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.text     "body",                     limit: 65535
    t.integer  "sort_order",               limit: 4
    t.integer  "page_category_id",         limit: 4
    t.integer  "department_id",            limit: 4
    t.integer  "admin_id",                 limit: 4
    t.string   "apikey",                   limit: 255
    t.string   "url_slug",                 limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size",    limit: 4
    t.datetime "cover_image_updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.text     "body",                     limit: 65535
    t.integer  "page_category_id",         limit: 4
    t.integer  "department_id",            limit: 4
    t.string   "template",                 limit: 255
    t.integer  "admin_id",                 limit: 4
    t.string   "url_slug",                 limit: 255
    t.string   "apikey",                   limit: 255
    t.integer  "sort_order",               limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size",    limit: 4
    t.datetime "cover_image_updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",       limit: 255
    t.string   "last_name",        limit: 255
    t.string   "email",            limit: 255
    t.string   "password_hash",    limit: 255
    t.string   "password_salt",    limit: 255
    t.string   "apikey",           limit: 255
    t.string   "password_recover", limit: 255
    t.string   "status",           limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
