class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :ai_generations, dependent: :destroy
  has_many :stories, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end
