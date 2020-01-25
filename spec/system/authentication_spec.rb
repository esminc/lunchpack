require 'rails_helper'

RSpec.describe 'ユーザー認証機能', type: :system do
  it 'ログインとログアウトする' do
    visit new_user_session_path
    click_on 'signin-link'

    expect(page).to have_content 'Google アカウントによる認証に成功しました。'
    expect(page).to have_current_path root_path, ignore_query: true

    within 'nav' do
      find('a', text: 'その他').click
      click_on 'ログアウト'
    end

    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end
end
