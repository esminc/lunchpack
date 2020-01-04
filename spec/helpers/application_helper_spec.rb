require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#countdown_days' do
    subject { helper.countdown_days }

    before do
      travel_to today
    end

    context '今日が40期第1Qの最終日の場合' do
      let(:today) { Date.new(2019, 10, 31) }

      it { is_expected.to eq 1 }
    end

    context '今日が40期第2Qの初日の場合' do
      let(:today) { Date.new(2019, 11, 1) }

      # 30日 (11月) + 31日 (12月) + 31日 (1月) = 92日
      it { is_expected.to eq 92 }
    end
  end
end
