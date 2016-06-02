ActiveRecord::Schema.define do
  create_table "widgets", force: :cascade do |t|
    t.string "name", limit: 255
  end

  if ActiveRecord::Base.connection.adapter_name.downcase =~ /mysql/
    create_table "advisory_locks", id: false, force: :cascade do |t|
      t.integer "lock_id", limit: 8
    end
    add_index "advisory_locks", ["lock_id"], name: "index_advisory_locks_on_lock_id", unique: true
  end
end
