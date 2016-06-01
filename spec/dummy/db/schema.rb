ActiveRecord::Schema.define do
  create_table "widgets", force: :cascade do |t|
    t.string "name", limit: 255
  end

  if ActiveRecord::Base.connection.adapter_name.downcase =~ /mysql/
    create_table "advisory_locks", id: false, force: :cascade do |t|
      t.string "name", limit: 128
    end
    add_index "advisory_locks", ["name"], name: "index_advisory_locks_on_name", unique: true
  end
end
