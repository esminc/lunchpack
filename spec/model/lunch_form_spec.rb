require 'rails_helper'

RSpec.describe LunchForm do
  describe 'dateのバリデーション' do
    let(:lunch_form_params) { {date: date , members: ['鈴木一郎', '鈴木二郎', '鈴木三郎']} }

    before do
      create(:member, real_name: '鈴木一郎')
      create(:member, real_name: '鈴木二郎')
      create(:member, real_name: '鈴木三郎')
    end

    subject { described_class.new(lunch_form_params) }

    context '日付が今日の場合' do
      let(:date) { Date.current.to_s }

      it { is_expected.to be_valid }
    end

    context '日付が明日の場合' do
      let(:date) { Date.tomorrow.to_s }

      it { is_expected.not_to be_valid }

      it '「今日までの日付を入力してください」のエラーメッセージになること' do
        subject.valid?
        expect(subject.errors.messages).to eq({date: ['今日までの日付を入力してください']})
      end
    end
  end

  describe 'membersのバリデーション' do
    let(:lunch_form_params) { {date: '2019-11-21', members: members} }

    before do
      create(:member, real_name: '鈴木一郎')
      create(:member, real_name: '鈴木二郎')
      create(:member, real_name: '鈴木三郎')
    end

    subject { described_class.new(lunch_form_params) }

    context '存在する３人がmembersに指定された場合' do
      let(:members) { ['鈴木一郎', '鈴木二郎', '鈴木三郎'] }

      it { is_expected.to be_valid }
    end

    context '存在する2人がmembersに指定された場合' do
      let(:members) { ['鈴木一郎', '鈴木二郎'] }

      it { is_expected.not_to be_valid }

      it '「3人のメンバーを入力してください」のエラーメッセージになること' do
        subject.valid?
        expect(subject.errors.messages).to eq({members: ['3人のメンバーを入力してください']})
      end
    end

    context '人数は満たしているが、存在しないmembersが指定された場合' do
      let(:members) { ['鈴木存在しない一郎', '鈴木二郎', '鈴木三郎'] }

      it { is_expected.not_to be_valid }

      it '「存在する名前を入力してください」のエラーメッセージになること' do
        subject.valid?
        expect(subject.errors.messages).to eq({members: ['存在する名前を入力してください']})
      end
    end

    context '人数を満たしておらず、存在しないmembersが指定された場合' do
      let(:members) { ['鈴木存在しない一郎', '鈴木二郎'] }

      it { is_expected.not_to be_valid }

      it 'それぞれのエラーメッセージが返されること' do
        subject.valid?
        expect(subject.errors.messages).to eq({members: ['3人のメンバーを入力してください', '存在する名前を入力してください']})
      end
    end
  end
end
