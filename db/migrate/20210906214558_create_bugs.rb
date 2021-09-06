class CreateBugs < ActiveRecord::Migration[6.1]
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :description
      t.integer :priority
      t.integer :status
      t.string :comments
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
