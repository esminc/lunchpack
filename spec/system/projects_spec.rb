require 'rails_helper'

describe 'プロジェクト管理機能' do
  before do
    create(:project)
    sign_in create(:user)
    visit root_path
    click_link 'プロジェクト'
  end

  describe '一覧表示機能' do
    it '名前が表示されているか' do
      expect(page).to have_content 'eiwakun'
    end
  end

  describe '新規作成機能' do
    context '名前が入力される場合' do
      it '新規に追加できること' do
        find('#new-btn').click
        fill_in 'project[name]', with: 'プロダクト'
        find('#submit-btn').click
        expect(page).to have_content 'プロダクトを登録しました'
      end
    end

    context '名前が入力されない場合' do
      it '新規に追加できないこと' do
        find('#new-btn').click
        find('#submit-btn').click
        expect(page).to have_content 'プロジェクト名を入力してください'
      end
    end
  end

  describe '編集機能' do
    it '名前が編集できるか' do
      find('.edit-btn').click
      fill_in 'project[name]', with: 'eiwasan'
      find('#submit-btn').click
      expect(page).to have_content 'eiwasanを更新しました'
    end
  end

  describe '削除機能' do
    it '削除できるか' do
      find('.delete-btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content 'eiwakunを削除しました'
    end
  end
end
