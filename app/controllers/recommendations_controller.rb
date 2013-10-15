class RecommendationsController < ApplicationController
  before_filter :signed_in_user

  def new
  	@service = Service.new
  	@recommendation = current_user.recommendations.new(:service_id => @service.id)
  end
end

