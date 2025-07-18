class UsersController < ApplicationController
  def index; end

  def show
    @users = User.find_by id: params[:id]
    return unless @users

    flash[:warning] = "Not found user!"
    redirect_to root_path
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end
end
