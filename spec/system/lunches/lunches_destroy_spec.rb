require 'rails_helper'

RSpec.describe 'ランチ履歴を登録したユーザーだけその履歴を削除できる機能', type: :system do
  before do
    create(:member, real_name: '鈴木一郎')
    create(:member, real_name: '鈴木二郎')
    create(:member, real_name: '鈴木三郎')

    sign_in create(:user)
    visit root_path

    find('.member-name', text: '鈴木一郎').click
    find('.member-name', text: '鈴木二郎').click
    find('.member-name', text: '鈴木三郎').click
    within('.lunch-form') do
      click_on('ランチに行く')
    end

    visit lunches_path
  end

  it '自分の登録した履歴は削除ボタンから削除できること' do
    within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
      click_on('削除')
    end
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を削除しました')
    within('table') do
      expect(page).not_to have_content('鈴木一郎,鈴木二郎,鈴木三郎')
    end
  end

  it '他人が登録した履歴には削除ボタンが無いこと' do
    sign_in create(:user, email: 'other@esm.co.jp')
    visit lunches_path

    within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
      expect(page).not_to have_content('削除')
    end
  end
end
