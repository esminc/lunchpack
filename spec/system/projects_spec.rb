require 'rails_helper'

RSpec.describe 'プロジェクト管理機能', type: :system do
  before do
    sign_in create(:user)
  end

  describe '一覧表示機能' do
    before do
      create(:project, name: 'eiwakun')
    end

    it '登録済みのプロジェクトが一覧に表示されていること' do
      visit projects_path

      within('table') do
        expect(page).to have_content 'eiwakun'
      end
    end
  end

  describe '新規作成機能' do
    it '新規に追加できること' do
      visit projects_path
      click_on 'プロジェクト追加'

      fill_in 'プロジェクト名', with: '新eiwakun'
      click_on '登録する'

      expect(page).to have_content '新eiwakunを登録しました'
      within('table') do
        expect(page).to have_content '新eiwakun'
      end
    end

    it '名前を入力しないとエラーメッセージが表示されること' do
      visit projects_path
      click_on 'プロジェクト追加'

      click_on '登録する'

      expect(page).to have_content 'プロジェクト名を入力してください'
    end
  end

  describe '編集機能' do
    before do
      create(:project, name: 'eiwakun')
    end

    it 'プロジェクト名が編集できること' do
      visit projects_path

      within('table tr', text: 'eiwakun') do
        click_on '編集'
      end

      fill_in 'プロジェクト名', with: 'EIWAKUN'
      click_on '更新する'

      expect(page).to have_content 'EIWAKUNを更新しました'
      within('table') do
        expect(page).not_to have_content 'eiwakun'
        expect(page).to have_content 'EIWAKUN'
      end
    end
  end

  describe '削除機能' do
    before do
      create(:project, name: 'eiwakun')
    end

    it '削除できること' do
      visit projects_path

      within('table tr', text: 'eiwakun') do
        click_on '編集'
      end

      click_on '削除する'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'eiwakunを削除しました'
      within('table') do
        expect(page).not_to have_content 'eiwakun'
      end
    end
  end
end
