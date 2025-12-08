module PeriodStoriesHelper
  def short_period_message(post)
    text = post.message.to_s

    first_sentence = text.split(/。|！|!|？|\?|¥n|\n/).compact_blank.first
    first_sentence ||= text

    first_sentence.truncate(40)
  end
end
