require 'rails_helper'

RSpec.describe 'ランチ履歴の登録機能', type: :system do
  let!(:project) { create(:project) }
  let!(:member1) { create(:member, real_name: '鈴木一郎', projects: [project]) }
  let!(:member2) { create(:member, real_name: '鈴木二郎') }
  let!(:member3) { create(:member, real_name: '鈴木三郎') }
  let!(:login_user) { create(:user, email: 'login@esm.co.jp') }

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
          expect(page).not_to have_content('鈴木一郎')
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
            expect(page).not_to have_content('鈴木二郎')
          end

          find('.member-row', text: '鈴木三郎').click

          within('.lunch-form') do
            expect(page).not_to have_content('鈴木三郎')
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
            expect(page).not_to have_content('鈴木一郎とランチ済み')
          end
          within('.member-row', text: '鈴木三郎') do
            expect(page).not_to have_content('鈴木一郎とランチ済み')
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
      create(:member, real_name: 'ろぐいん', email: 'login@esm.co.jp')

      visit root_path
    end

    it 'フォームの一人目にログインユーザーが入力されているか' do
      expect(first('.member-form').value).to eq 'ろぐいん'
    end
  end
end
