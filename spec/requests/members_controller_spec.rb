require 'rails_helper'

RSpec.describe MembersController, type: :request do
  describe 'PATCH #update' do
    let!(:member) { create(:member, real_name: '永和旧太郎') }

    before do
      sign_in create(:user)
    end

    context 'パラメータが妥当な場合' do
      let(:params) { {member: {real_name: '永和新太郎'}} }

      it '氏名が更新されること' do
        expect { patch member_url(member, params: params) }
          .to change { member.reload.real_name }.from('永和旧太郎').to('永和新太郎')
      end

      it 'リダイレクトすること' do
        patch member_url(member, params: params)
        expect(response).to redirect_to members_url
      end
    end

    context 'パラメータが不当な場合' do
      let(:params) { {member: {real_name: ''}} }

      it '氏名が更新されないこと' do
        expect { patch member_url(member, params: params) }.not_to change { member.reload.real_name }
      end

      it 'エラーメッセージが表示されること' do
        patch member_url(member, params: params)
        expect(response.body).to include '氏名を入力してください'
      end
    end
  end
end
