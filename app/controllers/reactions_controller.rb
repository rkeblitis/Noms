class ReactionsController < ApplicationController
  before_action :current_time

  def save_reaction
    if params[:reaction] == "meh"
      Reaction.create(photo_id: params[:pic_id], reaction: params[:reaction], user_id: session[:user_id])

    elsif params[:reaction] == "nom"
      Reaction.create(photo_id: params[:pic_id], reaction: params[:reaction], user_id: session[:user_id])

    elsif params[:reaction] == "flag"
      Reaction.create(photo_id: params[:pic_id], reaction: params[:reaction], user_id: session[:user_id])
    end
    puts Reaction.count
    render json: []
  end

  def results
    results = Reaction.check_if_done(@current_time, @time_range, session[:user_id])
    render json: results
  end

  private

  def current_time
    @current_time = session[:current_time]
    # 900 sec == 15 mins
    @time_range = @current_time + (900)
  end

end
