require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  describe "GET /index" do
    it "ログイン済みなら 200 を返す" do
      sign_in user
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "ログイン済みなら 200 を返す" do
      sign_in user
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "ログイン済みなら 200 を返す" do
      sign_in user
      get post_path(post_record)
      expect(response).to have_http_status(:success)
    end
  end
end
