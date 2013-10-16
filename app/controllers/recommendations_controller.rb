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
      redirect_to @current_user
  	end

  end
end

