ActiveRecord::Schema.define do
  create_table "widgets", force: :cascade do |t|
    t.string "name", limit: 255
  end

  if /mysql/.match?(ActiveRecord::Base.connection.adapter_name.downcase)
    create_table "transactional_advisory_locks", id: false, force: :cascade do |t|
      t.integer "lock_id", limit: 8
    end
    add_index "transactional_advisory_locks", ["lock_id"], name: "index_transactional_advisory_locks_on_lock_id", unique: true
  end
end
