class AddNameToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :name, :string
  end
end
