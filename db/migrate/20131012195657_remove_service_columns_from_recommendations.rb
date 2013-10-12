class RemoveServiceColumnsFromRecommendations < ActiveRecord::Migration
  def up
    remove_column :recommendations, :rec_category_id
    remove_column :recommendations, :link_type
    remove_column :recommendations, :email
    remove_column :recommendations, :phone
    remove_column :recommendations, :latitude
    remove_column :recommendations, :longitude
    remove_column :recommendations, :name
  end

  def down
    add_column :recommendations, :name, :string
    add_column :recommendations, :longitude, :float
    add_column :recommendations, :latitude, :float
    add_column :recommendations, :phone, :string
    add_column :recommendations, :email, :string
    add_column :recommendations, :link_type, :integer
    add_column :recommendations, :rec_category_id, :integer
  end
end
