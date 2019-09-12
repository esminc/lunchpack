require 'rails_helper'

describe 'メンバー管理機能', type: :system do
  before do
    create(:project)
    create(:member, hundle_name: 'taro', real_name: '山田太郎')
    sign_in create(:user)
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
    context '名前が入力される場合' do
      it '新規に追加できること' do
        find('#new-btn').click
        fill_in 'member[hundle_name]', with: 'hanako'
        fill_in 'member[real_name]', with: '山田花子'
        find('#submit-btn').click
        expect(page).to have_content '山田花子を登録しました'
      end
    end

    context '名前が入力されない場合' do
      it '新規に追加できないこと' do
        find('#new-btn').click
        find('#submit-btn').click
        expect(page).to have_content 'ニックネームを入力してください'
        expect(page).to have_content '氏名を入力してください'
      end
    end
  end

  describe '編集機能' do
    it 'ハンドルネームと氏名を編集できるか' do
      find('.edit-btn').click
      fill_in 'member[hundle_name]', with: 'taro3'
      fill_in 'member[real_name]', with: '山下太郎'
      find('#submit-btn').click
      expect(page).to have_content '山下太郎を更新しました'
      expect(page).to have_content 'taro3'
    end

    it 'プロジェクトを選択できるか' do
      find('.edit-btn').click
      find('.select2-selection__rendered').click
      find('.select2-results__options:first-child').click
      find('#submit-btn').click
      expect(page).to have_content 'eiwakun'
    end
  end

  describe 'メンバーを退職済みにする機能' do
    before do
      create(:member, real_name: '退職太郎')

      visit members_path
      within('tr', text: '退職太郎') do
        click_on 'edit'
      end

      # 退職済みをチェックする
      find('span', text: '退職済み').click

      click_on('更新する')
    end

    it '退職メンバーに退職済みのラベルが表示されること' do
      within('tr', text: '退職太郎') do
        expect(find('span')['data-badge-caption']).to eq '退職済み'
      end
    end

    it '選択リストには退職メンバーの名前が無いこと' do
      visit root_path
      within('#members-list') do
        expect(page).to_not have_content '退職太郎'
      end
    end
  end

  describe '削除機能' do
    it '削除できるか' do
      find('.delete-btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content '山田太郎を削除しました'
    end
  end
end
