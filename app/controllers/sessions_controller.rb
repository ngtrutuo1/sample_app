class SessionsController < ApplicationController
  # GET: /login
  def new; end

  # POST  : /login
  def create
    user = find_user

    if authenticated? user
      handle_successful_login user
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
    User.find_by email: params.dig(:session, :email)&.downcase
  end

  def authenticated? user
    user&.authenticate params.dig(:session, :password)
  end

  def handle_successful_login user
    log_in user
    handle_remember_me(user)

    flash[:success] = t(".login_successfully")
    redirect_back_or user
  end

  def handle_remember_me user
    return unless remember_me_checked?

    remember user
  end

  def remember_me_checked?
    params.dig(:session,
               :remember_me) == Settings.development.params.remember_me
  end
end
