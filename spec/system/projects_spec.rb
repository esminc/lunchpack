require 'rails_helper'

describe 'プロジェクト管理機能' do
  before do
    FactoryBot.create(:project)
    sign_in FactoryBot.create(:user)
    visit root_path
    click_link 'プロジェクト'
  end

  describe '一覧表示機能' do
    it '名前が表示されているか' do
      expect(page).to have_content 'eiwakun'
    end
  end

  describe '新規作成機能' do
    it '新規に追加できるか' do
      find('#new-btn').click
      fill_in 'project[name]', with: 'プロダクト'
      find('#submit-btn').click
      expect(page).to have_content 'プロダクト'
    end
  end

  describe '編集機能' do
    it '名前が編集できるか' do
      find('.edit-btn').click
      fill_in 'project[name]', with: 'eiwasan'
      find('#submit-btn').click
      expect(page).to have_content 'eiwasan'
    end
  end

  describe '削除機能' do
    it '削除できるか' do
      find('.delete-btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_content 'eiwakun'
    end
  end
end
