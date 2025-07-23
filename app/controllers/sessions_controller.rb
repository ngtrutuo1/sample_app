class SessionsController < ApplicationController
  # GET: /login
  def new; end

  # POST  : /login
  def create
    user = find_user
    if authenticated? user
      log_in user
      if params.dig(:session,
                    :remember_me) == Settings.development.params.remember_me
        remember(user)
      else
        forget(user)
      end
      flash[:success] = t(".login_successfully")
      redirect_to user, status: :see_other
    else
      flash.now[:danger] = t(".invalid_login_information")
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE  : /logout
  def destroy
    log_out
    redirect_to root_path status: :see_other
  end

  private
  def find_user
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def authenticated? user
    user&.authenticate(params.dig(:session, :password))
  end
end
