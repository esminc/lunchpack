require 'rails_helper'

def create_lunch(members, user, date: Date.today)
  quarter = Quarter.find_or_create_quarter(date)
  create(:lunch, members: members, date: date, quarter: quarter, created_by: user)
end

describe 'ランチ履歴の表示機能' do
  before do
    member1 = create(:member, real_name: '鈴木一郎')
    member2 = create(:member, real_name: '鈴木二郎')
    member3 = create(:member, real_name: '鈴木三郎')
    member4 = create(:member, real_name: '鈴木四郎')
    member5 = create(:member, real_name: '鈴木五郎')
    trio1 = [member1, member2, member3]
    trio2 = [member1, member4, member5]

    login_user = create(:user)
    create_lunch(trio1, login_user, date: Date.new(2019,9,15))
    create_lunch(trio2, login_user, date: Date.new(2019,9,16))
    create_lunch(trio1, login_user, date: Date.new(2019,12,15))

    sign_in login_user
    visit root_path
  end

  it 'クオーターごとに履歴が表示される' do
    visit lunches_path

    expect(page).to have_content('2019-09-15')
    expect(page).to have_content('2019-09-16')

    click_on('40期-2Q')

    expect(page).to have_content('2019-12-15')
  end
end

describe 'ランチ履歴を登録したユーザーだけその履歴を削除できる機能' do
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
      click_on('delete')
    end
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を削除しました')
    within('table') do
      expect(page).to_not have_content('鈴木一郎,鈴木二郎,鈴木三郎')
    end
  end

  it '他人が登録した履歴には削除ボタンが無いこと' do
    sign_in create(:user, email: 'other@esm.co.jp')
    visit lunches_path

    within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
      expect(page).to_not have_content('delete')
    end
  end
end

describe '3人組を探す機能' do
  let!(:project) { create(:project) }
  let!(:member1) { create(:member, real_name: '鈴木一郎', projects: [project]) }
  let!(:member2) { create(:member, real_name: '鈴木二郎') }
  let!(:member3) { create(:member, real_name: '鈴木三郎') }
  let!(:login_user) { create(:user) }

  before do
    create(:member, projects: [project])

    sign_in login_user
    visit root_path
  end

  describe 'メンバー選択リスト' do
    it 'メンバーがリストに表示されること' do
      expect(find('#members-list')).to have_content('鈴木一郎')
      expect(find('#members-list')).to have_content('鈴木二郎')
      expect(find('#members-list')).to have_content('鈴木三郎')
    end
  end

  describe 'メンバーを選択する' do
    it '名前をクリックすると枠に移動するか' do
      find('.member-name', text: '山田太郎').click

      expect(first('.member-form').value).to eq '山田太郎'
      expect(find('#members-list')).to_not have_content('山田太郎')
    end

    context '同じプロジェクトに所属するメンバー同士の組み合わせの場合' do
      it 'メンバーの表示が消えて選択できない' do
        find('.member-name', text: '山田太郎').click

        expect(find('#members-list')).to_not have_content('鈴木一郎')
      end
    end

    context 'すでにランチに行っているメンバー同士の組み合わせを選択する場合' do
      before do
        create_lunch([member1, member2, member3], login_user)

        visit root_path
      end

      context 'ランチに行ったクウォーターと同じ期間の場合' do
        it 'すでにランチに行ったメンバーの表示が消えること' do
          find('.member-name', text: '鈴木一郎').click

          expect(find('#members-list')).to_not have_content('鈴木二郎')
          expect(find('#members-list')).to_not have_content('鈴木三郎')
        end
      end

      context 'ランチに行ったクウォーターと違う期間の場合' do
        before do
          travel 3.month
          visit root_path
        end

        it 'すでにランチに行ったメンバーが表示があること' do
          find('.member-name', text: '鈴木一郎').click

          expect(find('#members-list')).to have_content('鈴木二郎')
          expect(find('#members-list')).to have_content('鈴木三郎')
        end
      end
    end
  end

  describe 'ランチに行ったことの登録機能' do
    context '3人を選ぶ場合' do
      it 'ランチに行ったことが登録できること' do
        find('.member-name', text: '鈴木一郎').click
        find('.member-name', text: '鈴木二郎').click
        find('.member-name', text: '鈴木三郎').click
        find('#submit-btn').click

        expect(page).to have_content '鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を登録しました'
      end
    end

    context '3人未満を選ぶ場合' do
      it 'ランチに行ったことが登録できないこと' do
        find('.member-name', text: '鈴木一郎').click
        find('.member-name', text: '鈴木二郎').click
        find('#submit-btn').click

        expect(page).to have_content '3人のメンバーを入力してください'
      end
    end
  end

  describe 'ログインしているユーザーが自動でフォームの一人目に入力される機能' do
    before do
      create(:member, real_name: 'ろぐいん', email: 'sample@esm.co.jp')

      visit root_path
    end

    it 'フォームの一人目にログインユーザーが入力されているか' do
      expect(first('.member-form').value).to eq 'ろぐいん'
    end
  end
end
