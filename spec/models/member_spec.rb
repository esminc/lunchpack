require 'rails_helper'

RSpec.describe Member do
  subject { described_class.new(handle_name: handle_name, real_name: real_name, email: 'sample@esm.co.jp') }

  let(:handle_name) { 'yama' }
  let(:real_name) { '山本太郎' }

  context 'メールアドレスが他のメンバーと重複する場合' do
    before { create(:member, email: 'sample@esm.co.jp') }

    it { is_expected.not_to be_valid }
  end

  context 'ハンドルネームがない場合' do
    let(:handle_name) { '' }

    it { is_expected.not_to be_valid }
  end

  context '氏名がない場合' do
    let(:real_name) { '' }

    it { is_expected.not_to be_valid }
  end
end
