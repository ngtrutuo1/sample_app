class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  before_action :load_user_by_email, only: :create

  # GET /password_resets/new
  def new; end

  # GET /password_resets/:id/edit
  def edit; end

  # POST /password_resets
  # redirect to root_path if email found
  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t(".reset_email_sent")
    redirect_to root_path
  end

  # PATCH /password_resets/:id
  def update
    if user_params[:password].empty?
      flash[:info] = t("users.password.blank")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params.merge(reset_digest: nil)
      UserMailer.resend_confirmation_after_reset(@user).deliver_now
      flash[:success] = t(".reset_password_successfully")
      redirect_to root_url, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_PERMIT_FOR_PASSWORD_RESET
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("users.edit.user_not_found")
    redirect_to root_path
  end

  def load_user_by_email
    email = params.dig(:password_reset, :email)&.downcase
    @user = User.find_by(email:)
    return if @user

    flash.now[:danger] = t(".email_not_found")
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t(".password_reset_invalid")
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".password_reset_expired")
    redirect_to new_password_reset_url
  end
end
