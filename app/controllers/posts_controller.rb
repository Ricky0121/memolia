class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show]

  def index
    @posts = current_user.posts.order(created_at: :desc)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.posted_on ||= Date.today

    if @post.save
      redirect_to @post, notice: "投稿を作成しました。"
    else
      Rails.logger.debug "POST_SAVE_ERRORS: #{@post.errors.full_messages.inspect}"
      flash.now[:alert] = "投稿に失敗しました。入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image_url, :message, :posted_on)
  end
end
