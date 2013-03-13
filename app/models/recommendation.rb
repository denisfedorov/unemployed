class Recommendation < ActiveRecord::Base
  attr_accessible :comment, :email, :latitude, :longitude, :phone, :photo, :rec_category_id, :service_id
end
