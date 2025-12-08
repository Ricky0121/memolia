require "rails_helper"

RSpec.describe "認証機能", type: :system do
  it "新規登録できる" do
    visit new_user_registration_path

    fill_in "user_name", with: "テスト"
    fill_in "user_email", with: "test@example.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"

    click_button "Sign up"

    expect(page).to have_content "アカウント登録が完了しました"
    expect(page).not_to have_current_path new_user_registration_path
  end

  it "ログインできる" do
    user = create(:user)

    visit new_user_session_path

    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "Log in"

    expect(page).to have_content "ログインしました"
    expect(page).not_to have_current_path new_user_session_path
  end

  it "ログアウトできる" do
    user = create(:user)

    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password"
    click_button "Log in"

    click_button "ログアウト"

    expect(page).to have_content "ログアウトしました"
    expect(page).to have_current_path root_path
  end
end
