class Recommendation < ActiveRecord::Base
  attr_accessible :name, :comment, :email, :latitude, :longitude, :phone, :photo, :rec_category_id, :service_id
  before_save :prepare_data_before_save

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: {:if => :phone.nil?}


  private
  	def prepare_data_before_save
  	end
  	
end
