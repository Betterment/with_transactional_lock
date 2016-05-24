class CreateAdvisoryLocks < ActiveRecord::Migration
  def change
    create_table :advisory_locks, id: false do |t|
      t.string :name
    end
    add_index :advisory_locks, :name, unique: true
  end
end
