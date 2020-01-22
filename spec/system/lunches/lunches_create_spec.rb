require 'rails_helper'

RSpec.describe 'ランチ履歴の登録機能', type: :system do
  let(:login_user) { create(:user, email: 'login@esm.co.jp') }

  before do
    sign_in login_user
  end

  describe '表からメンバーを選択する機能' do
    describe '一度選択しても戻せるしくみ' do
      before do
        create(:member, real_name: '鈴木一郎')
        create(:member, real_name: '鈴木二郎')
        create(:member, real_name: '鈴木三郎')
      end

      it '名前が入ったフォームをクリックすると表に名前が戻ること' do
        visit root_path

        within('table') do
          find('.member-row', text: '鈴木一郎').click
          find('.member-row', text: '鈴木二郎').click
          find('.member-row', text: '鈴木三郎').click

          expect(page).not_to have_content '鈴木一郎'
          expect(page).not_to have_content '鈴木二郎'
          expect(page).not_to have_content '鈴木三郎'
        end

        find('label', text: '１人目').click
        find('label', text: '２人目').click
        find('label', text: '３人目').click

        within('table') do
          expect(page).to have_content '鈴木一郎'
          expect(page).to have_content '鈴木二郎'
          expect(page).to have_content '鈴木三郎'
        end
      end
    end

    describe '3人まで選択できるしくみ' do
      before do
        create(:member, real_name: '鈴木一郎')
        create(:member, real_name: '鈴木二郎')
        create(:member, real_name: '鈴木三郎')
        create(:member, real_name: '鈴木四郎')
      end

      it '名前をクリックすると3人までフォームに名前が移動すること' do
        visit root_path

        within('table') do
          find('.member-row', text: '鈴木一郎').click
          find('.member-row', text: '鈴木二郎').click
          find('.member-row', text: '鈴木三郎').click
          find('.member-row', text: '鈴木四郎').click

          expect(page).not_to have_content '鈴木一郎'
          expect(page).not_to have_content '鈴木二郎'
          expect(page).not_to have_content '鈴木三郎'
          expect(page).to have_content '鈴木四郎'
        end

        expect(page).to have_field '１人目', with: '鈴木一郎'
        expect(page).to have_field '２人目', with: '鈴木二郎'
        expect(page).to have_field '３人目', with: '鈴木三郎'
      end
    end

    describe '選択できるメンバーの制限について' do
      context '同じプロジェクトに所属するメンバー同士を選ぶ場合' do
        let(:project) { create(:project) }

        before do
          create(:member, real_name: '鈴木一郎', projects: [project])
          create(:member, real_name: '鈴木二郎', projects: [project])
        end

        it '選択できない理由が表示され、クリックしても名前がフォームに移動しないこと' do
          visit root_path

          within('table') do
            find('.member-row', text: '鈴木一郎').click

            expect(find('.member-row', text: '鈴木二郎')).to have_content '鈴木一郎と同じプロジェクト'

            find('.member-row', text: '鈴木二郎').click
          end

          expect(page).to have_field '１人目', with: '鈴木一郎'
          expect(page).to have_field '２人目', with: ''
        end
      end

      context 'すでにランチに行っているメンバー同士を選ぶ場合' do
        before do
          members = [
            create(:member, real_name: '鈴木一郎'),
            create(:member, real_name: '鈴木二郎'),
            create(:member, real_name: '鈴木三郎')
          ]
          create_lunch(members, login_user, date: lunch_date)
        end

        context 'すでに行ったランチが現在のクウォーターと同じ期間の場合' do
          let(:lunch_date) { Date.current }

          it '選択できない理由が表示され、クリックしても名前がフォームに移動しないこと' do
            visit root_path

            within('table') do
              find('.member-row', text: '鈴木一郎').click

              expect(find('.member-row', text: '鈴木二郎')).to have_content '鈴木一郎とランチ済み'
              expect(find('.member-row', text: '鈴木三郎')).to have_content '鈴木一郎とランチ済み'

              find('.member-row', text: '鈴木二郎').click
              find('.member-row', text: '鈴木三郎').click
            end

            expect(page).to have_field '２人目', with: ''
            expect(page).to have_field '３人目', with: ''
          end
        end

        context 'すでに行ったランチが現在のクウォーターと違う期間の場合' do
          let(:lunch_date) { 3.months.ago }

          it '選択できない理由が表示されず、クリックすると名前がフォームに移動すること' do
            visit root_path

            within('table') do
              find('.member-row', text: '鈴木一郎').click

              expect(find('.member-row', text: '鈴木二郎')).not_to have_content '鈴木一郎とランチ済み'
              expect(find('.member-row', text: '鈴木三郎')).not_to have_content '鈴木一郎とランチ済み'

              find('.member-row', text: '鈴木二郎').click
              find('.member-row', text: '鈴木三郎').click
            end

            expect(page).to have_field '２人目', with: '鈴木二郎'
            expect(page).to have_field '３人目', with: '鈴木三郎'
          end
        end
      end
    end
  end

  describe 'ログインユーザーの名前がフォームの一人目に入力されるしくみ' do
    context 'ログインユーザーと同じメールアドレスをもつメンバーが登録されている場合' do
      before do
        create(:member, real_name: 'ろぐいん太郎', email: login_user.email)
      end

      it 'フォームの１人目にログインユーザーが入力されていること' do
        visit root_path

        expect(page).to have_field '１人目', with: 'ろぐいん太郎'
      end
    end
  end

  describe 'ランチに行ったことの登録機能' do
    before do
      create(:member, real_name: '鈴木一郎')
      create(:member, real_name: '鈴木二郎')
      create(:member, real_name: '鈴木三郎')
    end

    describe '日付の入力' do
      context '今日の日付で登録する場合' do
        let(:lunch_date) { Date.current }

        it '正しく登録されたことのメッセージが表示されること' do
          visit root_path

          within('table') do
            find('.member-row', text: '鈴木一郎').click
            find('.member-row', text: '鈴木二郎').click
            find('.member-row', text: '鈴木三郎').click
          end

          fill_in '行った日', with: lunch_date
          click_on '登録する'

          expect(page).to have_content "#{lunch_date} 鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を登録しました"
        end
      end

      context '前の期の日付で登録する場合' do
        let(:lunch_date) { Date.current.prev_month(3) }

        it '正しく登録されたことのメッセージが表示されること' do
          visit root_path

          within('table') do
            find('.member-row', text: '鈴木一郎').click
            find('.member-row', text: '鈴木二郎').click
            find('.member-row', text: '鈴木三郎').click
          end

          fill_in '行った日', with: lunch_date
          click_on '登録する'

          expect(page).to have_content "#{lunch_date} 鈴木一郎,鈴木二郎,鈴木三郎の給付金利用履歴を登録しました"
        end
      end

      context '日付を空にする場合' do
        it 'エラーメッセージが表示されること' do
          visit root_path

          within('table') do
            find('.member-row', text: '鈴木一郎').click
            find('.member-row', text: '鈴木二郎').click
            find('.member-row', text: '鈴木三郎').click
          end

          fill_in '行った日', with: nil
          click_on '登録する'

          expect(page).to have_content '日付を入力してください'
        end
      end
    end

    describe 'メンバーの入力' do
      context '3人メンバーを選ばない場合' do
        it 'エラーメッセージが表示されること' do
          visit root_path

          within('table') do
            find('.member-row', text: '鈴木一郎').click
            find('.member-row', text: '鈴木二郎').click
          end

          click_on '登録する'

          expect(page).to have_content '3人のメンバーを入力してください'
        end
      end
    end
  end
end
