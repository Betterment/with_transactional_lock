class CreateAdvisoryLocks < ActiveRecord::Migration
  def change
    create_table :advisory_locks, id: false do |t|
      t.string :name, unique: true, null: false
    end
  end
end
