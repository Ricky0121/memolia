class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    service = StoryGenerationService.new(user: current_user, post: @post)
    story = service.call

    if story.present?
      flash[:notice] = t("flash.stories.create.success")
    else
      flash[:alert] = t("flash.stories.create.failure")
    end

    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = current_user.posts.find(params[:post_id])
  end
end
