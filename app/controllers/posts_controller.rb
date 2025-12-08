class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show]

  def index
    @posts = current_user.posts.order(created_at: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.posted_on ||= Time.zone.today

    if @post.save
      redirect_to @post, notice: t("flash.posts.create.success")
    else
      flash.now[:alert] = t("flash.posts.create.failure")
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image_url, :message, :posted_on)
  end
end
