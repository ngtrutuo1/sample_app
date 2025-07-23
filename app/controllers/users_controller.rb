class UsersController < ApplicationController
  include SessionsHelper

  before_action :require_login, only: %i(show)
  before_action :load_user, only: %i(show)

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t("layout.welcome_to_the_sample_app")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def require_login
    return if logged_in?

    redirect_to login_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("layout.user_not_found")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end
end
