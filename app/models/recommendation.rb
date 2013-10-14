class Recommendation < ActiveRecord::Base
  attr_accessible :comment, :photo, :service_id

  belongs_to :user
  belongs_to :service
  
  before_save :prepare_data_before_save

  validates :service_id, :presence => true
  validates :user_id, :presence => true

  private
  	def prepare_data_before_save
  	end
  	
end
