class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  before_action :set_session_time
  before_action :set_session_user_id
  # helper_method :current_time

  def set_session_time
    if session[:current_time] == nil
      session[:current_time] = Time.now
    else
      if
        session[:current_time] < 5.minutes.ago
        session[:current_time] = Time.now
      else
        session[:current_time] = Time.parse(session[:current_time])
      end
    end
  end

  # def current_time
  #   @current_time = session[:current_time]
  #   # 900 sec == 15 mins
  #   @time_range = @current_time + (900)
  # end

  def set_session_user_id
    if session[:user_id] == nil
      current_user_id = SecureRandom.base64
      session[:user_id] = current_user_id
    else
      session[:user_id] = session[:user_id]
    end
  end

end
