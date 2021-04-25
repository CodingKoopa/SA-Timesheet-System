class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :privilege
      t.integer :org
      t.integer :org2
      t.integer :grad
      t.integer :manager_id
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
