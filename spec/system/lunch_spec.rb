require 'rails_helper'

describe '3人組を探す機能' do
  before do
    project = FactoryBot.create(:project)
    FactoryBot.create(:member, projects: [project])
    FactoryBot.create(:member, real_name: '鈴木一郎', projects: [project])
    sign_in FactoryBot.create(:user)
    visit root_path
  end

  describe 'メンバー選択' do
    it '名前をクリックすると枠に移動するか' do
      find('.member-name', text: '山田太郎').click
      expect(find('.selected-member-box:first-child')).to have_content('山田太郎')
      expect(find('#members-list')).to_not have_content('山田太郎')
    end

    it '名前をクリックすると同じプロジェクトのメンバーの表示が消えるか' do
      find('.member-name', text: '山田太郎').click
      expect(find('#members-list')).to_not have_content('鈴木一郎')
    end
  end
end
