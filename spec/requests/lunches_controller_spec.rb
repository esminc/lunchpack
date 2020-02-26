require 'rails_helper'

RSpec.describe LunchesController, type: :request do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:quarter) { create(:quarter) }

    before do
      sign_in user
    end

    context 'ランチの登録者の場合' do
      let!(:lunch) { create(:lunch, quarter: quarter, created_by: user) }

      it '削除されること' do
        expect { delete lunch_url(lunch) }.to change { Lunch.count }.by(-1)
      end
    end

    context 'ランチの登録者ではない場合' do
      let!(:other_user) { create(:user) }
      let!(:lunch) { create(:lunch, quarter: quarter, created_by: other_user) }

      it '削除されないこと' do
        delete lunch_url(lunch)
        expect { delete lunch_url(lunch) }.not_to change { Lunch.count }
      end
    end
  end
end
