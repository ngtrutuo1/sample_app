module SessionsHelper
  def log_in user
    reset_session
    session[:user_id] = user.id
    user.remember
    session[:remember_token] = user.remember_token
  end

  def current_user
    return @current_user if defined? @current_user

    @current_user = user_from_cookies || user_from_session
  end

  def current_user? user
    user.present? && user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
    session.delete :remember_token
  end

  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember user
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default, status: :see_other
    session.delete :forwarding_url
  end

  private

  def user_from_session
    return unless user_id = session[:user_id]

    user = User.find_by id: user_id
    user if user&.authenticated? :remember, session[:remember_token]
  end

  def user_from_cookies
    return unless user_id = cookies.signed[:user_id]
    return unless remember_token = cookies[:remember_token]

    user = User.find_by(id: user_id)
    return unless user&.authenticated? :remember, remember_token

    user
  end
end
