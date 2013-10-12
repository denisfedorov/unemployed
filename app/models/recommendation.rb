class Recommendation < ActiveRecord::Base
  attr_accessible :comment, :photo
  before_save :prepare_data_before_save

  private
  	def prepare_data_before_save
  	end
  	
end
