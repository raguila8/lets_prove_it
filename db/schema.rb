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

ActiveRecord::Schema.define(version: 20190109051138) do

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.string "action"
    t.integer "acted_on_id"
    t.string "acted_on_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_on"
    t.integer "linkable_id"
    t.string "linkable_type"
    t.index ["acted_on_id"], name: "index_activities_on_acted_on_id"
    t.index ["linkable_id"], name: "index_activities_on_linkable_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
    t.index [nil], name: "index_activities_on_reportable_id"
  end

  create_table "bookmarked_problems", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id", "user_id"], name: "index_bookmarked_problems_on_problem_id_and_user_id", unique: true
    t.index ["problem_id"], name: "index_bookmarked_problems_on_problem_id"
    t.index ["user_id"], name: "index_bookmarked_problems_on_user_id"
  end

  create_table "change_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "changes", force: :cascade do |t|
    t.integer "version_id"
    t.integer "change_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["change_type_id"], name: "index_changes_on_change_type_id"
    t.index ["version_id"], name: "index_changes_on_version_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.integer "commented_on_id"
    t.string "commented_on_type"
    t.string "deleted_by", default: "user"
    t.datetime "deleted_on"
    t.text "deleted_for"
    t.index ["commented_on_id"], name: "index_comments_on_commented_on_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "flag_reports", force: :cascade do |t|
    t.integer "flag_id"
    t.integer "report_id"
    t.index ["flag_id", "report_id"], name: "index_flag_reports_on_flag_id_and_report_id", unique: true
    t.index ["flag_id"], name: "index_flag_reports_on_flag_id"
    t.index ["report_id"], name: "index_flag_reports_on_report_id"
  end

  create_table "flags", force: :cascade do |t|
    t.string "name", null: false
    t.string "reportable_type", null: false
    t.text "description"
  end

  create_table "images", force: :cascade do |t|
    t.string "image_data"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.string "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.string "notified_object_type"
    t.integer "notified_object_id"
    t.string "attachment"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["notified_object_type", "notified_object_id"], name: "mailboxer_notifications_notified_object"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type"
    t.text "details", default: ""
  end

  create_table "problem_images", force: :cascade do |t|
    t.integer "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.index ["image_id"], name: "index_problem_images_on_image_id"
    t.index ["problem_id"], name: "index_problem_images_on_problem_id"
  end

  create_table "problem_topics", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_problem_topics_on_problem_id"
    t.index ["topic_id"], name: "index_problem_topics_on_topic_id"
  end

  create_table "problems", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.integer "cached_proofs_count", default: 0
    t.datetime "deleted_on"
    t.string "deleted_by"
    t.text "deleted_for"
    t.string "image"
    t.string "subtitle"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "proof_images", force: :cascade do |t|
    t.integer "proof_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.index ["image_id"], name: "index_proof_images_on_image_id"
    t.index ["proof_id"], name: "index_proof_images_on_proof_id"
  end

  create_table "proofs", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.datetime "deleted_on"
    t.string "deleted_by"
    t.text "deleted_for"
    t.index ["problem_id"], name: "index_proofs_on_problem_id"
    t.index ["user_id"], name: "index_proofs_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id"
    t.string "reason"
    t.integer "reportable_id"
    t.string "reportable_type"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "", null: false
    t.text "details", default: ""
    t.datetime "expired_on"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "reserved_reports", force: :cascade do |t|
    t.integer "user_id"
    t.integer "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_reserved_reports_on_report_id"
    t.index ["user_id", "report_id"], name: "index_reserved_reports_on_user_id_and_report_id", unique: true
    t.index ["user_id"], name: "index_reserved_reports_on_user_id"
  end

  create_table "topic_followings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id", "user_id"], name: "index_topic_followings_on_topic_id_and_user_id", unique: true
    t.index ["topic_id"], name: "index_topic_followings_on_topic_id"
    t.index ["user_id"], name: "index_topic_followings_on_user_id"
  end

  create_table "topic_images", force: :cascade do |t|
    t.integer "image_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_topic_images_on_image_id"
    t.index ["topic_id"], name: "index_topic_images_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "cached_problems_count", default: 0
    t.datetime "deleted_on"
    t.string "deleted_by"
    t.text "deleted_for"
    t.index ["name"], name: "index_topics_on_name"
  end

  create_table "user_topics", force: :cascade do |t|
    t.integer "user_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_user_topics_on_topic_id"
    t.index ["user_id"], name: "index_user_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "username", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar", default: "", null: false
    t.text "bio"
    t.string "occupation"
    t.string "education"
    t.string "location"
    t.integer "reputation", default: 0
    t.datetime "last_seen_at", default: "2018-11-07 20:18:46"
    t.datetime "deleted_on"
    t.string "deleted_by"
    t.text "deleted_for"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "version_topics", force: :cascade do |t|
    t.integer "version_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_version_topics_on_topic_id"
    t.index ["version_id"], name: "index_version_topics_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.integer "version_number"
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "versioned_id"
    t.string "versioned_type"
    t.datetime "deleted_on"
    t.string "deleted_by"
    t.text "deleted_for"
    t.index ["user_id"], name: "index_versions_on_user_id"
    t.index ["versioned_id", "versioned_type"], name: "index_versions_on_versioned_id_and_versioned_type"
    t.index ["versioned_id"], name: "index_versions_on_versioned_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

end
