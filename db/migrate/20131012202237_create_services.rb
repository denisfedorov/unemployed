class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :user_id
      t.string :name
      t.string :title
      t.integer :category_id
      t.string :email
      t.string :phone

      t.timestamps
    end

    add_index :services, :user_id
    add_index :services, :category_id

  end
end
