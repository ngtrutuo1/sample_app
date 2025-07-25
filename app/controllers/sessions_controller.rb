class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_authenticated, only: :create

  # GET: /login
  def new; end

  # POST  : /login
  def create
    return handle_login @user if @user.activated?

    flash[:warning] = t(".account_not_activated")
    redirect_to root_path, status: :see_other
  end

  # DELETE  : /logout
  def destroy
    log_out
    redirect_to root_path status: :see_other
  end

  private
  def load_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
  end

  def check_authenticated
    return if @user&.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t(".invalid_login_information")
    render :new, status: :unprocessable_entity
  end

  def handle_login user
    result = params.dig(:session,
                        :remember_me) == Settings.development.remember_me
    log_in user
    remember user if result

    flash[:success] = t(".login_successfully")
    redirect_back_or user
  end
end
