class Service < ActiveRecord::Base
  attr_accessible :category_id, :email, :location_id, :name, :phone, :title, :user_id
end
