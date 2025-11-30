class Post < ApplicationRecord
  belongs_to :user

  has_many :photos, dependent: :destroy
  has_many :ai_generations, dependent: :destroy
  has_one :story, dependent: :destroy

  enum status: { published: 0, draft: 1 }, _default: :published

  validates :message, presence: true, length: { maximum: 500 }
  validates :image_url, presence: true
end
