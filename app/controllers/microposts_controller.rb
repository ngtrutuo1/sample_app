class MicropostsController < ApplicationController
  before_action :require_login, only: %i(create destroy)
  before_action :authorize_user, only: :destroy

  # POST /microposts
  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t(".micropost_created")
    else
      flash[:danger] = t(".micropost_failed")
    end
    redirect_to root_url
  end

  # DELETE /microposts/:id
  def destroy
    if @micropost.destroy
      flash[:success] = t(".micropost_deleted")
    else
      flash[:danger] = t(".micropost_delete_failed")
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PERMIT
  end

  def authorize_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t(".micropost_invalid")
    redirect_to request.referer || root_url
  end
end
