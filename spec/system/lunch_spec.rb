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

describe 'ランチ履歴を登録したユーザーだけその履歴を削除できる機能', type: :system do
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
      expect(page).to_not have_content('鈴木一郎,鈴木二郎,鈴木三郎')
    end
  end

  it '他人が登録した履歴には削除ボタンが無いこと' do
    sign_in create(:user, email: 'other@esm.co.jp')
    visit lunches_path

    within('tr', text: '鈴木一郎,鈴木二郎,鈴木三郎') do
      expect(page).to_not have_content('削除')
    end
  end
end

describe '3人組を探す機能', type: :system do
  let!(:project) { create(:project) }
  let!(:member1) { create(:member, real_name: '鈴木一郎', projects: [project]) }
  let!(:member2) { create(:member, real_name: '鈴木二郎') }
  let!(:member3) { create(:member, real_name: '鈴木三郎') }
  let!(:login_user) { create(:user) }

  before do
    create(:member, real_name: '山田太郎', projects: [project])

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
    it '名前をクリックすると枠に名前が移動すること' do
      find('.member-name', text: '山田太郎').click

      expect(first('.member-form').value).to eq '山田太郎'
    end

    context '同じプロジェクトに所属するメンバー同士の組み合わせの場合' do
      before do
        find('.member-name', text: '山田太郎').click
      end

      it '〜と同じプロジェクトという理由が表示がされること' do
        within('.member-row', text: '鈴木一郎') do
          expect(page).to have_content('山田太郎と同じプロジェクト')
        end
      end

      it 'クリックしても名前がフォームに移動しないこと' do
        find('.member-row', text: '鈴木一郎').click

        within('.lunch-form') do
          expect(page).to_not have_content('鈴木一郎')
        end
      end
    end

    context 'すでにランチに行っているメンバー同士の組み合わせを選択する場合' do
      before do
        create_lunch([member1, member2, member3], login_user)

        visit root_path
      end

      context 'ランチに行ったクウォーターと同じ期間の場合' do
        it '〜とランチ済みという理由が表示がされること' do
          find('.member-name', text: '鈴木一郎').click

          within('.member-row', text: '鈴木二郎') do
            expect(page).to have_content('鈴木一郎とランチ済み')
          end
          within('.member-row', text: '鈴木三郎') do
            expect(page).to have_content('鈴木一郎とランチ済み')
          end
        end

        it 'クリックしても名前がフォームに移動しないこと' do
          find('.member-row', text: '鈴木二郎').click

          within('.lunch-form') do
            expect(page).to_not have_content('鈴木二郎')
          end

          find('.member-row', text: '鈴木三郎').click

          within('.lunch-form') do
            expect(page).to_not have_content('鈴木三郎')
          end
        end
      end

      context 'ランチに行ったクウォーターと違う期間の場合' do
        before do
          travel 3.months
          visit root_path
        end

        it '〜とランチ済みという理由が表示がないこと' do
          find('.member-name', text: '鈴木一郎').click

          within('.member-row', text: '鈴木二郎') do
            expect(page).to_not have_content('鈴木一郎とランチ済み')
          end
          within('.member-row', text: '鈴木三郎') do
            expect(page).to_not have_content('鈴木一郎とランチ済み')
          end
        end
      end
    end
  end

  describe 'ランチに行ったことの登録機能' do
    context '正しい入力をする場合' do
      context '今日の日付で登録する場合' do
        let(:date) { Date.current }

        it '正しく登録されたことのメッセージが表示されること' do
          find('.member-name', text: '鈴木一郎').click
          find('.member-name', text: '鈴木二郎').click
          find('.member-name', text: '鈴木三郎').click
          fill_in '行った日', with: date
          find('#submit-btn').click

          expect(page).to have_content '鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を登録しました'
        end
      end

      context '前の期の日付で登録する場合' do
        let(:date) { Date.current.prev_month(3) }

        it '正しく登録されたことのメッセージが表示されること' do
          find('.member-name', text: '鈴木一郎').click
          find('.member-name', text: '鈴木二郎').click
          find('.member-name', text: '鈴木三郎').click
          fill_in '行った日', with: date
          find('#submit-btn').click

          expect(page).to have_content "#{Date.current.prev_month(3)} 鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を登録しました"
        end
      end
    end

    context '不正な入力をする場合' do
      it 'エラーメッセージが表示されること' do
        find('.member-name', text: '鈴木一郎').click
        find('.member-name', text: '鈴木二郎').click
        fill_in '行った日', with: nil
        find('#submit-btn').click

        expect(page).to have_content '3人のメンバーを入力してください'
        expect(page).to have_content '日付を入力してください'
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
