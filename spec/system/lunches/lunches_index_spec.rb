require 'rails_helper'

describe 'ランチ履歴の表示機能', type: :system do
  before do
    member1 = create(:member, real_name: '鈴木一郎')
    member2 = create(:member, real_name: '鈴木二郎')
    member3 = create(:member, real_name: '鈴木三郎')
    member4 = create(:member, real_name: '鈴木四郎')
    member5 = create(:member, real_name: '鈴木五郎')
    trio1 = [member1, member2, member3]
    trio2 = [member1, member4, member5]

    login_user = create(:user)
    create_lunch(trio1, login_user, date: Date.new(2019, 9, 15))
    create_lunch(trio2, login_user, date: Date.new(2019, 9, 16))
    create_lunch(trio1, login_user, date: Date.new(2019, 12, 15))

    sign_in login_user
    visit root_path
  end

  it 'クオーターごとに履歴が表示される' do
    visit lunches_path
    click_on('40期-1Q')
    expect(page).to have_content('2019-09-15 鈴木一郎,鈴木二郎,鈴木三郎')
    expect(page).to have_content('2019-09-16 鈴木一郎,鈴木四郎,鈴木五郎')

    click_on('40期-2Q')
    expect(page).to have_content('2019-12-15 鈴木一郎,鈴木二郎,鈴木三郎')
  end
end
