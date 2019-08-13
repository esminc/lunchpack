require 'rails_helper'

describe 'メンバー管理機能', type: :system do
  before do
    FactoryBot.create(:project)
    FactoryBot.create(:member)
    sign_in FactoryBot.create(:user)
    visit root_path
    click_link 'メンバー'
  end

  describe '一覧表示機能' do
    it 'ハンドルネームと氏名が表示されているか' do
      expect(page).to have_content 'taro'
      expect(page).to have_content '山田太郎'
    end
  end

  describe '新規作成機能' do
    it '新規に追加できるか' do
      find('#new-btn').click
      fill_in 'member[hundle_name]', with: 'hanako'
      fill_in 'member[real_name]', with: '山田花子'
      find('#submit-btn').click
      expect(page).to have_content 'hanako'
      expect(page).to have_content '山田花子'
    end
  end

  describe '編集機能' do
    it 'ハンドルネームと氏名を編集できるか' do
      find('.edit-btn').click
      fill_in 'member[hundle_name]', with: 'taro3'
      fill_in 'member[real_name]', with: '山下太郎'
      find('#submit-btn').click
      expect(page).to have_content 'taro3'
      expect(page).to have_content '山下太郎'
    end

    it 'プロジェクトを選択できるか' do
      find('.edit-btn').click
      find('.select2-selection__rendered').click
      find('.select2-results__options:first-child').click
      find('#submit-btn').click
      expect(page).to have_content 'eiwakun'
    end
  end

  describe '削除機能' do
    it '削除できるか' do
      find('.delete-btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content 'taro'
      expect(page).to_not have_content '山田太郎'
    end
  end
end
