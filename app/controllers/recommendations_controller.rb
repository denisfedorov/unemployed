# encoding: UTF-8
class RecommendationsController < ApplicationController
  before_filter :signed_in_user

  def new
  	@service = Service.new
  	@recommendation = current_user.recommendations.new(:service_id => @service.id)
  end

  def create
  	@service = Service.new(params[:service])
  	if @service.save
  		@recommendation = current_user.recommendations.new(:service_id => @service.id)
  		@recommendation.save
      flash[:success] = "Спасибо! Рекомендация добавлена."
      redirect_to root_url
  	end
  end

  def index
    @recommendations = current_user.recommendations.paginate(page: params[:page])
  end

  def destroy
    rec = current_user.recommendations.find(params[:id])
    if rec.service.is_built_from_recommendation? and rec.service.recommendations.count == 1
      rec.service.destroy # the recommendation should get destroyed as well 
    else
      rec.destroy
    end
    flash[:success] = "Recommendation deleted."
    redirect_to recommendations_url
  end

end

