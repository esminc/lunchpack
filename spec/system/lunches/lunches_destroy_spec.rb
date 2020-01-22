require 'rails_helper'

RSpec.describe 'ランチ履歴を登録したユーザーだけその履歴を削除できる機能', type: :system do
  let(:user) { create(:user) }
  let(:members) do
    [
      create(:member, real_name: '鈴木一郎'),
      create(:member, real_name: '鈴木二郎'),
      create(:member, real_name: '鈴木三郎')
    ]
  end

  before do
    sign_in user
  end

  context '自分が登録した履歴の場合' do
    before do
      create_lunch(members, user, date: Date.current)
    end

    it '削除ボタンから削除ができること' do
      visit lunches_path

      within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
        click_on '削除'
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を削除しました'
      within('table') do
        expect(page).not_to have_content '鈴木一郎,鈴木二郎,鈴木三郎'
      end
    end
  end

  context '他のユーザーが登録した履歴の場合' do
    let(:other_user) { create(:user) }

    before do
      create_lunch(members, other_user, date: Date.current)
    end

    it '削除ボタンが無いこと' do
      visit lunches_path

      within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
        expect(page).not_to have_content '削除'
      end
    end
  end
end
