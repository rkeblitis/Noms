class ReactionsController < ApplicationController
  # before_action :current_time

  # def current_time
  #   @current_time = session[:current_time]
  #   # 900 sec == 15 mins
  #   @time_range = @current_time + (900)
  # end

  def save_reaction
    Reaction.create(photo_id: params[:pic_id], reaction: params[:reaction], user_id: session[:user_id])
    render json: []
  end

  def results
    results = Reaction.check_if_done(session[:user_id], params[:lat].to_f, params[:lon].to_f)
    render json: results
  end

end
