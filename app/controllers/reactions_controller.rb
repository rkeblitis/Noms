class ReactionsController < ApplicationController


  def save_reaction
    Reaction.create(photo_id: params[:pic_id], reaction: params[:reaction], user_id: session[:user_id])
    render json: []
  end

  def results
    results = Reaction.check_if_done(session[:user_id], params[:lat].to_f, params[:lon].to_f)
    render json: results
  end

end
