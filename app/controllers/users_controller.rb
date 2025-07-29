class UsersController < ApplicationController
  include SessionsHelper

  before_action :require_login, only: %i(index edit update show)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :admin_user, only: :destroy
  before_action :can_update_user, only: %i(edit update)

  def show
    @page, @microposts = pagy @user.microposts.recent,
                              items: Settings.development.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".acc_activation_message")
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @user = User.find_by id: params[:id]
    if @user.update user_params
      flash[:success] = t(".profile_updated")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @pagy, @users = pagy(User.recent, items: Settings.development.page_10)
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".deleted", name: @user.name)
    else
      flash[:danger] = t(".fail", name: @user.name)
    end

    redirect_to users_path
  end

  private

  def admin_user
    return if current_user.admin?

    flash[:danger] = t(".not_authorized")
    redirect_to root_path
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

  def can_update_user
    return if current_user? @user

    flash[:warning] = t(".cannot_edit")
    redirect_to root_path
  end
end
