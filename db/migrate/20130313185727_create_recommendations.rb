class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :rec_category_id
      t.integer :link_type
      t.string :email
      t.string :phone
      t.integer :service_id
      t.float :latitude
      t.float :longitude
      t.text :comment
      t.string :photo

      t.timestamps
    end

    add_index :recommendations, [:user_id, :created_at]
    add_index :recommendations, [:service_id]
  end
end
