FactoryBot.define do
  factory :period_story do
    user { nil }
    ai_generation { nil }
    title { "MyString" }
    body { "MyText" }
    period_start_on { "2025-12-07" }
    period_end_on { "2025-12-07" }
    period_type { 1 }
  end
end
