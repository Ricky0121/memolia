class PeriodStory < ApplicationRecord
  belongs_to :user
  belongs_to :ai_generation

  enum :period_type, {
    weekly: 0,
    monthly: 10,
    custom: 20
  }

  scope :saved, -> { where(saved: true) }

  validates :title, presence: true
  validates :body,  presence: true
  validates :period_start_on, presence: true
  validates :period_end_on,   presence: true
  validate  :period_range_valid

  def period_range_valid
    return if period_start_on.blank? || period_end_on.blank?

    return unless period_start_on > period_end_on

    errors.add(:period_end_on, "は開始日以降の日付を指定してください")
  end
end
