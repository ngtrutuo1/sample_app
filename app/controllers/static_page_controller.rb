class StaticPageController < ApplicationController
  # GET: /
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.microposts.recent,
                              items: Settings.development.page_10
  end

  # GET: /help
  def help; end
end
