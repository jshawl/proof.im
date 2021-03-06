# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_10_181410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "handles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_handles_on_name", unique: true
  end

  create_table "identities", force: :cascade do |t|
    t.string "username"
    t.bigint "handle_id", null: false
    t.bigint "proof_id"
    t.string "public_claim_url"
    t.integer "kind", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle_id"], name: "index_identities_on_handle_id"
    t.index ["proof_id"], name: "index_identities_on_proof_id"
  end

  create_table "keys", force: :cascade do |t|
    t.bigint "handle_id", null: false
    t.string "kind"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fingerprint"
    t.index ["handle_id"], name: "index_keys_on_handle_id"
  end

  create_table "proofs", force: :cascade do |t|
    t.bigint "key_id", null: false
    t.string "signature"
    t.string "claim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0
    t.string "username"
    t.string "public_claim_url"
    t.index ["key_id"], name: "index_proofs_on_key_id"
  end

  add_foreign_key "identities", "handles"
  add_foreign_key "identities", "proofs"
  add_foreign_key "keys", "handles"
  add_foreign_key "proofs", "keys"
end
