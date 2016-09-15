class CreateTransactionalAdvisoryLocks < ActiveRecord::Migration
  def change
    create_table :transactional_advisory_locks, id: false do |t|
      t.integer :lock_id, null: false, limit: 8
    end
    add_index(:transactional_advisory_locks, :lock_id, unique: true, name: 'index_transactional_advisory_locks_on_lock_id')
  end
end
