require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do

    # 認証済みのユーザーとして
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status '200'
      end
    end

    # ゲストとして
    context "as a guest" do
      # テストをここに書く
    end
  end
end
