require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe 'POST #google' do
    context '妥当なリクエストの場合' do
      it 'トップページへリダイレクトすること' do
        post user_google_omniauth_callback_url
        expect(response).to redirect_to root_url
      end
    end

    context '不正なリクエストの場合' do
      before do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
          Faker::Omniauth.google(email: '')
        )
      end

      after do
        OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
          Faker::Omniauth.google(email: Faker::Internet.unique.email(domain: 'esm.co.jp'))
        )
      end

      it ' サインインページにリダイレクトすること' do
        post user_google_omniauth_callback_url
        expect(response).to redirect_to new_user_registration_url
      end
    end
  end
end
