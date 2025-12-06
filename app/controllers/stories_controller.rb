class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    service = StoryGenerationService.new(user: current_user, post: @post)
    story = service.call

    if story.present?
      flash[:notice] = "ストーリーを生成しました。"
    else
      flash[:alert] = "ストーリーの生成に失敗しました。時間をおいて再度お試しください。"
    end

    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = current_user.posts.find(params[:post_id])
  end
end
