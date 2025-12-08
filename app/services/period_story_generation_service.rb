class PeriodStoryGenerationService
  MODEL_NAME = "gpt-5-mini".freeze

  def initialize(user:, period_start_on:, period_end_on:, period_type: :weekly)
    @user = user
    @period_start_on = period_start_on
    @period_end_on   = period_end_on
    @period_type     = period_type
  end

  def call
    posts = @user.posts
                 .where(posted_on: @period_start_on..@period_end_on)
                 .order(:posted_on)

    return nil if posts.empty?

    prompt = build_prompt(posts)

    ai_generation = AiGeneration.create!(
      user: @user,
      post: posts.first,
      model: MODEL_NAME,
      status: :processing,
      prompt: prompt
    )

    response = OPENAI_CLIENT.chat.completions.create(
      model: MODEL_NAME,
      messages: [
        {
          role: :system,
          content: "あなたは家族や友人との日常を、やさしい日本語の物語にまとめるストーリーテラーです。"
        },
        {
          role: :user,
          content: prompt
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

    PeriodStory.create!(
      user: @user,
      ai_generation: ai_generation,
      title: parsed[:title],
      body: parsed[:body],
      period_start_on: @period_start_on,
      period_end_on: @period_end_on,
      period_type: @period_type
    )
  rescue StandardError => e
    Rails.logger.error("[PeriodStoryGenerationService] #{e.class}: #{e.message}")
    ai_generation&.update(
      status: :failed,
      error_message: "#{e.class}: #{e.message}"
    )
    nil
  end

  private

  def build_prompt(posts)
    lines = posts.map do |post|
      date_str = post.posted_on&.strftime("%Y-%m-%d")
      "- #{date_str} : #{post.message}（画像URL: #{post.image_url.presence || 'なし'}）"
    end

    <<~PROMPT
      以下は、ユーザーの日々の投稿です。
      期間: #{@period_start_on.strftime('%Y-%m-%d')} 〜 #{@period_end_on.strftime('%Y-%m-%d')}

      投稿一覧:
      #{lines.join("\n")}

      これらの投稿をもとに、1週間を振り返る心あたたまるストーリーを日本語で作成してください。

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
      title: json["title"].presence || "1週間のストーリー",
      body: json["body"].presence || content
    }
  rescue JSON::ParserError
    lines = content.to_s.split(/\R/)
    {
      title: (lines.shift || "1週間のストーリー").truncate(50),
      body: lines.join("\n").presence || content
    }
  end
end
