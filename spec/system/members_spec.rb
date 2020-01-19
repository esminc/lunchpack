require 'rails_helper'

RSpec.describe 'メンバー管理機能', type: :system do
  before do
    sign_in create(:user)
  end

  describe '一覧表示機能' do
    before do
      create(:member, handle_name: 'taro', real_name: '山田太郎', email: 'taro-yamada@example.com')
    end

    it 'ニックネーム、氏名、メールアドレスが表示されていること' do
      visit members_path

      within('table tr', text: '山田太郎') do
        expect(find('.handle_name')).to have_content 'taro'
        expect(find('.real_name')).to have_content '山田太郎'
        expect(find('.email')).to have_content 'taro-yamada@example.com'
      end
    end
  end

  describe '新規作成機能' do
    context 'ニックネームと氏名が入力される場合' do
      it '新規に追加できること' do
        visit members_path
        click_on 'メンバー追加'

        fill_in 'ニックネーム', with: 'hanako'
        fill_in '氏名', with: '山田花子'
        fill_in 'メールアドレス', with: 'hanako-yamada@example.com'
        click_on '登録する'

        expect(page).to have_content '山田花子を登録しました'
        within('tbody tr', text: '山田花子') do
          expect(find('.handle_name')).to have_content 'hanako'
          expect(find('.real_name')).to have_content '山田花子'
          expect(find('.email')).to have_content 'hanako-yamada@example.com'
        end
      end
    end

    context 'ニックネームと氏名が入力されない場合' do
      it 'エラーメッセージが表示されて、新規に追加できないこと' do
        visit members_path
        click_on 'メンバー追加'

        click_on '登録する'

        expect(page).to have_content 'ニックネームを入力してください'
        expect(page).to have_content '氏名を入力してください'
      end
    end
  end

  describe '編集機能' do
    before do
      create(:project, name: 'eiwakun')
      create(:member, handle_name: 'taro', real_name: '山田太郎', email: 'taro-yamada@example.com')
    end

    it '編集できること' do
      visit members_path
      click_on '編集'

      fill_in 'ニックネーム', with: 'hanako'
      fill_in '氏名', with: '山田花子'
      fill_in 'メールアドレス', with: 'hanako-yamada@example.com'

      # プロジェクトの入力
      find('.select2-selection__rendered').click
      find('.select2-results__options', text: 'eiwakun').click
      click_on '更新する'

      expect(page).to have_content '山田花子を更新しました'
      within('tr', text: '山田花子') do
        expect(find('.handle_name')).to have_content 'hanako'
        expect(find('.real_name')).to have_content '山田花子'
        expect(find('.email')).to have_content 'hanako-yamada@example.com'
        expect(find('.projects')).to have_content 'eiwakun'
      end
    end
  end

  describe 'メンバーを退職済みにする機能' do
    before do
      create(:member, real_name: '退職太郎')
    end

    it '退職済みにしたメンバーは退職済みのラベルが表示され、選択リストには表示されないこと' do
      visit members_path
      within('tr', text: '退職太郎') do
        click_on '編集'
      end

      check '退職済み'
      click_on '更新する'

      expect(page).to have_content '退職太郎を更新しました'
      within('tr', text: '退職太郎') do
        expect(find('.status')).to have_content '退職済み'
      end

      visit root_path
      within('#members-list') do
        expect(page).not_to have_content '退職太郎'
      end
    end
  end

  describe '削除機能' do
    before do
      create(:member, handle_name: 'taro', real_name: '山田太郎', email: 'taro-yamada@example.com')
    end

    it '削除できること' do
      visit members_path
      within('table tr', text: '山田太郎') do
        click_on '編集'
      end

      click_on '削除する'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '山田太郎を削除しました'
      within('table') do
        expect(page).not_to have_content '山田太郎'
      end
    end
  end
end
