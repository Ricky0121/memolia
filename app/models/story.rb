class Story < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :ai_generation, optional: true

  validates :title, presence: true
  validates :body, presence: true
  validates :generated_on, presence: true
end
