class AiGeneration < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :story, dependent: :nullify
  has_one :period_story, dependent: :nullify

  enum :status, {
    pending: 0,
    processing: 10,
    succeeded: 20,
    failed: 30
  }, default: :pending
end
