require 'rails_helper'

RSpec.describe 'プロジェクト管理機能', type: :system do
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
        click_on 'プロジェクト追加'
        fill_in 'project[name]', with: 'プロダクト'
        click_on '登録する'
        expect(page).to have_content 'プロダクトを登録しました'
      end
    end

    context '名前が入力されない場合', js: false do
      it '新規に追加できないこと' do
        click_on 'プロジェクト追加'
        click_on '登録する'
        expect(page).to have_content 'プロジェクト名を入力してください'
      end
    end
  end

  describe '編集機能' do
    it '名前が編集できるか' do
      click_on '編集'
      fill_in 'project[name]', with: 'eiwasan'
      click_on '更新する'
      expect(page).to have_content 'eiwasanを更新しました'
    end
  end

  describe '削除機能' do
    it '削除できるか' do
      click_on '編集'
      click_on '削除する'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'eiwakunを削除しました'
    end
  end
end
