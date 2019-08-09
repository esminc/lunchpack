require 'rails_helper'

describe '3人組を探す機能' do
  before do
    FactoryBot.create(:member)
    sign_in FactoryBot.create(:user)
    visit root_path
  end
  describe 'メンバー選択' do
    it '名前をクリックすると枠に移動するか' do
      find('.member-name').click
      expect(find('.selected-member-box:first-child')).to have_content('山田太郎')
    end
  end
end
