class StaticPageController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.microposts.recent,
                              items: Settings.development.page_10
  end

  def help; end
end
