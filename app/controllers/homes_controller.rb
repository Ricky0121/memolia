class HomesController < ApplicationController
  def index
    return unless user_signed_in?

    redirect_to posts_path
  end
end
