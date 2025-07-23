module SessionsHelper
  def log_in user
    reset_session
    session[:user_id] = user.id
    user.remember
    session[:remember_token] = user.remember_token
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = user_from_session || user_from_cookies
  end

  def logged_in?
    current_user.present?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_tokenend
    session.delete :remember_token
  end

  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  private

  def user_from_session
    return unless (user_id = session[:user_id])

    User.find_by(id: user_id)
  end

  def user_from_cookies
    return unless (user_id = cookies.signed[:user_id])

    user = User.find_by(id: user_id)
    return unless user&.authenticated?(cookies[:remember_token])

    log_in(user)
    user
  end
end
