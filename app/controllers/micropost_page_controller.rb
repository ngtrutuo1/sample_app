class MicropostPageController < ApplicationController
  def home
    @microposts = Micropost.recent
  end
end
