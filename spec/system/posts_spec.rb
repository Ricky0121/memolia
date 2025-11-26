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

    fill_in "画像URL", with: "https://example.com/sample.jpg"
    fill_in "メッセージ", with: "テスト投稿です"

    click_button "投稿する"

    expect(page).not_to have_content "エラーがあります"

    expect(page).to have_content "テスト投稿です"

    expect(Post.exists?(message: "テスト投稿です")).to be true
  end

  it "投稿一覧に作成済みの投稿が表示される" do
    post = create(:post,
                  user: user,
                  image_url: "https://example.com/list.jpg",
                  message: "一覧テスト")

    log_in(user)

    visit posts_path

    expect(page).to have_content "一覧テスト"
    expect(page).to have_selector("img[src='https://example.com/list.jpg']")

    click_link post.message
    expect(page).to have_current_path post_path(post)
  end

  it "バリデーションエラー時にエラーメッセージが表示される" do
    log_in(user)

    visit new_post_path

    click_button "投稿する"

    expect(page).to have_content "エラーがあります"
  end
end
