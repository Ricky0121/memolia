class AiGeneration < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :story, dependent: :nullify

  enum status: {
    processing: 0,
    success: 1,
    failed: 2
  }

  validates :model, presence: true
  validates :prompt, presence: true
end
