FactoryBot.define do
  factory :post do
    association :user
    image_url { "https://example.com/factory.jpg" }
    message { "テスト用の投稿です" }
    posted_on { Time.zone.today }
    status { :published }
  end
end
