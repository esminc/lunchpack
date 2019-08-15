require 'rails_helper'

describe '3人組を探す機能' do
  let!(:project) { create(:project) }
  let!(:member1) { create(:member, real_name: '鈴木一郎', projects: [project]) }
  let!(:member2) { create(:member, real_name: '鈴木二郎') }
  let!(:member3) { create(:member, real_name: '鈴木三郎') }

  before do
    create(:member, projects: [project])
    sign_in create(:user)
    visit root_path
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

    context 'すでにランチに行っているメンバー同士の組み合わせの場合' do
      before do
        create(:lunch, members: [member1, member2, member3])
        visit root_path
      end

      it 'メンバーの表示が消えて選択できない' do
        expect(find('#members-list')).to have_content('鈴木二郎')
        expect(find('#members-list')).to have_content('鈴木三郎')
        find('.member-name', text: '鈴木一郎').click
        expect(find('#members-list')).to_not have_content('鈴木二郎')
        expect(find('#members-list')).to_not have_content('鈴木三郎')
      end
    end
  end

  describe 'ランチに行ったことの登録機能' do
    before do
      find('.member-name', text: '鈴木一郎').click
      find('.member-name', text: '鈴木二郎').click
      find('.member-name', text: '鈴木三郎').click
    end

    it 'ランチに行ったことが登録されるか' do
      find('#submit-btn').click
      expect(page).to have_content 'Lunch was successfully created.'
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
