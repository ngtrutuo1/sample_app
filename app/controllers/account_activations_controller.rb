class AccountActivationsController < ApplicationController
  include SessionsHelper

  before_action :load_user, only: :edit
  before_action :check_activated, only: :edit
  before_action :check_authenticated, only: :edit

  def edit
    @user.activate
    log_in @user
    flash[:success] = t(".account_activated")
    redirect_to @user
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t(".invalid_activation")
    redirect_to root_path
  end

  def check_activated
    return unless @user.activated

    flash[:info] = t(".account_activated")
    redirect_to root_path
  end

  def check_authenticated
    return if @user.authenticated?(:activation, params[:id])

    flash[:danger] = t(".invalid_activation")
    redirect_to root_path
  end
end
