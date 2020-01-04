require 'rails_helper'

RSpec.describe Quarter do
  describe '.current_quarter' do
    subject(:current_quarter) { described_class.current_quarter }

    it '今日が含まれるクォーターが返されること' do
      expect(current_quarter.start_date..current_quarter.end_date).to cover(Date.current)
    end
  end

  describe '.find_or_create_quarter' do
    subject { described_class.find_or_create_quarter(Date.new(2019, 11, 14)) }

    context 'すでにQuarterがある場合' do
      before do
        create(:quarter, period: 40, ordinal: 2, start_date: Date.new(2019, 11, 1), end_date: Date.new(2020, 1, 31))
      end

      it '引数の日付に該当するQuarterが返されること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 2,
          start_date: Date.new(2019, 11, 1),
          end_date: Date.new(2020, 1, 31)
        ).and be_an_instance_of(described_class)
      end

      it 'Quarterのレコード数が増えないこと' do
        expect { subject }.not_to change { described_class.count }
      end
    end

    context 'まだQuarterがない場合' do
      it '引数の日付に該当するQuarterが返されること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 2,
          start_date: Date.new(2019, 11, 1),
          end_date: Date.new(2020, 1, 31)
        ).and be_an_instance_of(described_class)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { described_class.count }.by(1)
      end
    end
  end

  describe '#cover_today?' do
    subject { quarter.cover_today? }

    before '40期第2Qのときに実行する' do
      # 現在日時を固定
      travel_to Date.new(2019, 11, 1)
    end

    context '40期第2Qの場合' do
      let(:quarter) do
        build(:quarter, period: 40, ordinal: 2, start_date: Date.new(2019, 11, 1), end_date: Date.new(2020, 1, 31))
      end

      it { is_expected.to be true }
    end

    context '40期第1Qの場合' do
      let(:quarter) do
        build(:quarter, period: 40, ordinal: 1, start_date: Date.new(2019, 8, 1), end_date: Date.new(2019, 10, 31))
      end

      it { is_expected.to be false }
    end
  end
end
