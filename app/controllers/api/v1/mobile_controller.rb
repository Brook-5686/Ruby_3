# frozen_string_literal: true
class Api::V1::MobileController < ApplicationController
  skip_before_action :authenticated
  before_action :mobile_request?

  respond_to :json

  ALLOWED_CLASSES = ['User', 'Product', 'Order'].freeze

  def show
    if params[:class] && ALLOWED_CLASSES.include?(params[:class].classify)
      model = params[:class].classify.constantize
      respond_with model.find(params[:id]).to_json
    else
      render json: { error: 'Invalid class parameter' }, status: :bad_request
    end
  end

  def index
    if params[:class] && ALLOWED_CLASSES.include?(params[:class].classify)
      model = params[:class].classify.constantize
      respond_with model.all.to_json
    else
      respond_with nil.to_json
    end
  end

  private

  def mobile_request?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /ios|android/i
    end
  end
end
