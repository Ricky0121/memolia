class PeriodStoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_period_story, only: [:show, :save_to_list]

  def index
    @period_stories = current_user.period_stories.saved.order(created_at: :desc)
  end

  def show
    @posts_in_period = current_user.posts
                                   .where(posted_on: @period_story.period_start_on..@period_story.period_end_on)
                                   .where.not(image_url: [nil, ""])
                                   .order(:posted_on)
  end

  def generate_weekly
    period_end_on   = Date.current
    period_start_on = period_end_on - 6.days

    service = PeriodStoryGenerationService.new(
      user: current_user,
      period_start_on:,
      period_end_on:,
      period_type: :weekly
    )

    period_story = service.call

    if period_story
      redirect_to period_stories_path,
                  notice: t("flash.period_stories.generate_weekly.success")
    else
      redirect_to posts_path,
                  alert: t("flash.period_stories.generate_weekly.no_posts")
    end
  end

  def save_to_list
    if @period_story.update(saved: true)
      redirect_to period_stories_path,
                  notice: t("flash.period_stories.save_to_list.success")
    else
      redirect_to period_story_path(@period_story),
                  alert: t("flash.period_stories.save_to_list.failure")
    end
  end

  private

  def set_period_story
    @period_story = current_user.period_stories.find(params[:id])
  end
end
