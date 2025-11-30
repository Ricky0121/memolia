FactoryBot.define do
  factory :story do
    user { nil }
    post { nil }
    ai_generation { nil }
    title { "MyString" }
    body { "MyText" }
    generated_on { "2025-11-30" }
  end
end
