require 'rails_helper'

RSpec.describe LunchForm do
  describe 'membersのバリデーション' do
    context '存在する３人がmembersに指定された場合' do
      it '有効であること' do
      end
    end

    context '存在する2人がmembersに指定された場合' do
      it '有効でないこと' do
      end

      it '「3人のメンバーを入力してください」のエラーメッセージになること' do
      end
    end

    context '存在しない３人がmembersに指定された場合' do
      it '有効でないこと' do
      end

      it '「存在する名前を入力してください」のエラーメッセージになること' do
      end
    end
  end

  # describe '#must_have_benefits_available_count_members' do
  #   let(:lunch_form_params) { {date: '2019-11-21', members: members} }

  #   subject { described_class.new(lunch_form_params) }

  #   context '3 人指定されているとき' do
  #     let(:members) { ['111', 'bbb','ccc'] }

  #     it { is_expected.to be_valid }
  #   end

  #   context '2 人指定されているとき' do
  #     let(:members) { ['111', 'bbb'] }

  #     it { is_expected.not_to be_valid }
  #   end
  # end

  # describe '#members_should_exist' do
  #   let(:lunch_form_params) { {date: '2019-11-21', members: members} }

  #   subject { described_class.new(lunch_form_params) }

  #   before do
  #     create(:member, real_name: '鈴木一郎')
  #     create(:member, real_name: '鈴木二郎')
  #     create(:member, real_name: '鈴木三郎')
  #   end

  #   context '存在するメンバーの名前が渡されるとき' do
  #     let(:members) { ['鈴木一郎', '鈴木二郎', '鈴木三郎'] }

  #     it { is_expected.to be_valid }
  #   end

  #   context '存在しないメンバーの名前が渡されるとき' do
  #     let(:members) { ['鈴木存在しない一郎', '鈴木二郎', '鈴木三郎'] }

  #     it { is_expected.not_to be_valid }
  #   end
  # end
end
