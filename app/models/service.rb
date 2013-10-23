class Service < ActiveRecord::Base
  attr_accessible :category_id, :email, :location_id, :name, :phone, :title, :user_id, :description

  has_many :recommendations, dependent: :destroy
  
  def is_built_from_recommendation?
  	user_id.nil?
  end
end
