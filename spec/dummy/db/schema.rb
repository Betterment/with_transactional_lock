# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table "widgets", force: :cascade do |t|
    t.string "name", limit: 255
  end
end
