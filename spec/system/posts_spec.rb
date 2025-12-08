require "rails_helper"

RSpec.describe "投稿機能", type: :system do
  let(:user) { create(:user) }

  def log_in(user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "Log in"
  end

  it "新規投稿フォームから投稿処理が実行できる" do
    log_in(user)

    visit new_post_path

    find("input[name='post[image_url]']").set("https://example.com/sample.jpg")
    find("textarea[name='post[message]']").set("テスト投稿です")
    find("input[name='post[posted_on]']").set("2025-11-29")

    click_button "投稿する"

    expect(page).to have_current_path(%r{/posts/\d+}, ignore_query: true)

    expect(page).to have_content "投稿詳細"
    expect(page).to have_content "テスト投稿です"
    expect(page).to have_content "2025-11-29"

    expect(Post.exists?(message: "テスト投稿です")).to be true
  end

  it "バリデーションエラー時にエラーメッセージが表示される" do
    log_in(user)

    visit new_post_path

    click_button "投稿する"

    expect(page).to have_current_path("/posts")

    expect(page).to have_content "エラーがあります"

    expect(page).to have_content "Messageを入力してください"
    expect(page).to have_content "Image urlを入力してください"
  end

  it "投稿一覧と詳細が表示される" do
    log_in(user)

    post = Post.create!(
      user: user,
      image_url: "https://example.com/list_sample.jpg",
      message: "一覧テスト用の投稿です",
      posted_on: Time.zone.today
    )

    visit posts_path

    expect(page).to have_content "一覧テスト用の投稿です"

    find("a[href='#{post_path(post)}']").click

    expect(page).to have_current_path(post_path(post))

    expect(page).to have_content "投稿詳細"
    expect(page).to have_content "一覧テスト用の投稿です"
    expect(page).to have_content post.posted_on.to_s
  end
end
