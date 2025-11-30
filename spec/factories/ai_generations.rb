FactoryBot.define do
  factory :ai_generation do
    user { nil }
    post { nil }
    model { "MyString" }
    prompt { "MyText" }
    response { "MyText" }
    status { 1 }
    error_message { "MyText" }
    prompt_tokens { 1 }
    completion_tokens { 1 }
    total_tokens { 1 }
  end
end
