class Recommendation < ActiveRecord::Base
  attr_accessible :comment, :photo

  belongs_to :user
  belongs_to :service
  
  before_save :prepare_data_before_save

  private
  	def prepare_data_before_save
  	end
  	
end
