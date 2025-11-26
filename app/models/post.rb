class Post < ApplicationRecord
  belongs_to :user

  has_many :photos, dependent: :destroy

  enum status: { published: 0, draft: 1 }

  validates :message, presence: true, length: { maximum: 500 }
  validates :image_url, presence: true
end
