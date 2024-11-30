# frozen_string_literal: true
class DashboardController < ApplicationController
  skip_before_action :has_info
  layout false, only: [:change_graph]

  def home
    @user = current_user

    # See if the user has a font preference
    if params[:font]
      cookies[:font] = params[:font]
    end
  end

  def change_graph
    case params[:graph]
    when "bar_graph"
      bar_graph
    when "pie_charts"
      pie_charts
    else
      # Handle invalid graph type
      render plain: "Invalid graph type", status: :bad_request
      return
    end

    if params[:graph] == "bar_graph"
      render "dashboard/bar_graph"
    else
      @user = current_user
      render "dashboard/pie_charts"
    end
  end

  private

  def bar_graph
    render "dashboard/bar_graph"
  end

  def pie_charts
    @user = current_user
    render "dashboard/pie_charts"
  end
end
