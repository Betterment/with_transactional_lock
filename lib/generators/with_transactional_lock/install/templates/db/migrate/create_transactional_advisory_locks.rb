class CreateAdvisoryLocks < ActiveRecord::Migration
  def change
    create_table :transactional_advisory_locks, id: false do |t|
      t.integer :lock_id, unique: true, null: false, limit: 8
    end
  end
end
