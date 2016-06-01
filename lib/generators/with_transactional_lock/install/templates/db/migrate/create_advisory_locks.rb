class CreateAdvisoryLocks < ActiveRecord::Migration
  def change
    create_table :advisory_locks, id: false do |t|
      t.string :name, unique: true, null: false, limit: 128
    end
  end
end
