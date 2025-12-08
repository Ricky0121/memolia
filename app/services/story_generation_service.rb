class StoryGenerationService
  MODEL_NAME = "gpt-5-mini".freeze

  def initialize(user:, post:)
    @user = user
    @post = post
  end

  def call
    ai_generation = AiGeneration.create!(
      user: @user,
      post: @post,
      model: MODEL_NAME,
      status: :processing,
      prompt: build_prompt
    )

    response = OPENAI_CLIENT.chat.completions.create(
      model: MODEL_NAME,
      messages: [
        {
          role: :system,
          content: "あなたは家族や友人との思い出を、あたたかい日本語の物語に仕立てるストーリーテラーです。"
        },
        {
          role: :user,
          content: build_prompt
        }
      ]
    )

    content = response.choices.first.message[:content]
    usage   = response.usage || {}

    ai_generation.update!(
      response: content,
      status: :succeeded,
      prompt_tokens: usage[:prompt_tokens],
      completion_tokens: usage[:completion_tokens],
      total_tokens: usage[:total_tokens]
    )

    parsed = parse_response(content)

    Story.create!(
      user: @user,
      post: @post,
      ai_generation: ai_generation,
      title: parsed[:title],
      body: parsed[:body],
      generated_on: Date.current
    )
  rescue StandardError => e
    Rails.logger.error("[StoryGenerationService] #{e.class}: #{e.message}")
    ai_generation&.update(
      status: :failed,
      error_message: "#{e.class}: #{e.message}"
    )
    nil
  end

  private

  def build_prompt
    <<~PROMPT
      以下の投稿内容から、心あたたまる短いストーリーを日本語で作成してください。

      - メッセージ: #{@post.message}
      - 思い出の日付: #{@post.posted_on&.strftime('%Y-%m-%d')}
      - 画像URL: #{@post.image_url}

      次の JSON 形式で返してください:

      {
        "title": "タイトル（20文字前後）",
        "body": "本文（300〜600文字程度）"
      }
    PROMPT
  end

  def parse_response(content)
    json = JSON.parse(content)
    {
      title: json["title"].presence || "思い出のストーリー",
      body: json["body"].presence || content
    }
  rescue JSON::ParserError
    lines = content.to_s.split(/\R/)
    {
      title: (lines.shift || "思い出のストーリー").truncate(50),
      body: lines.join("\n").presence || content
    }
  end
end
