class UsersController < ApplicationController
  before_action :load_user, except: %i(new create)
  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      flash[:success] = t("layout.welcome_to_the_sample_app")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("layout.user_not_found")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def edit; end

  def update; end

  def destroy; end
end
