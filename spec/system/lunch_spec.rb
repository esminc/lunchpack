require 'rails_helper'

describe '3人組を探す機能' do
  before do
    project = create(:project)
    create(:member, projects: [project])
    create(:member, real_name: '鈴木一郎', projects: [project])
    create(:member, real_name: '鈴木二郎')
    create(:member, real_name: '鈴木三郎')
    sign_in create(:user)
    visit root_path
  end

  describe 'メンバー選択' do
    it '名前をクリックすると枠に移動するか' do
      find('.member-name', text: '山田太郎').click
      expect(first('.member-form').value).to eq '山田太郎'
      expect(find('#members-list')).to_not have_content('山田太郎')
    end

    it '名前をクリックすると同じプロジェクトのメンバーの表示が消えるか' do
      find('.member-name', text: '山田太郎').click
      expect(find('#members-list')).to_not have_content('鈴木一郎')
    end
  end

  describe 'ランチに行ったことの登録機能' do
    before do
      find('.member-name', text: '鈴木一郎').click
      find('.member-name', text: '鈴木二郎').click
      find('.member-name', text: '鈴木三郎').click
    end

    it 'ランチに行ったことが登録されるか' do
      find('#submit-btn').click
      expect(page).to have_content 'Lunch was successfully created.'
    end
  end
end
