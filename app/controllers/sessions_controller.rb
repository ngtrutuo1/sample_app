class SessionsController < ApplicationController
  # GET: /login
  def new; end

  # POST  : /login
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      log_in user
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
end
