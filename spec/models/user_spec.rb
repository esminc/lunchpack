require 'rails_helper'
require 'ostruct'

RSpec.describe User, type: :model do
  describe 'User.find_for_google' do
    subject { described_class.find_for_google(auth) }
    let(:auth) do
      OpenStruct.new(
        provider: :google,
        uid: '012345678901234567890',
        info: OpenStruct.new(email: 'user@esm.co.jp'),
        credentials: OpenStruct.new(token: '123abc')
      )
    end

    context '受け取ったemailと同じメールemailを持つ既存のユーザーがいる場合' do
      let!(:user) { create(:user, email: 'user@esm.co.jp', password: 'password') }

      it '既存のユーザーを返すこと' do
        expect(subject).to have_attributes(
          email: 'user@esm.co.jp',
          encrypted_password: user.encrypted_password
        )
      end

      it 'ユーザーのレコード数が増えないこと' do
        expect { subject }.not_to change { User.count }
      end
    end

    context '受け取ったemailと同じメールemailを持つ既存のユーザーがいない場合' do
      it '新しく作成したユーザーを返すこと' do
        expect(subject).to have_attributes(
          email: 'user@esm.co.jp',
          provider: 'google',
          uid: '012345678901234567890',
          token: '123abc',
          meta: auth.to_yaml
        )
      end

      it 'ユーザーのレコード数が増えること' do
        expect { subject }.to change { User.count }.by(1)
      end
    end
  end
end
