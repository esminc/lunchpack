require 'rails_helper'

describe Quarter do
  describe '.current_quarter' do
    it '今日のクォーターがとれること' do
      current_quarter = Quarter.current_quarter
      expect(current_quarter.start_date .. current_quarter.end_date).to cover(Date.today)
    end

    it 'すでに今日のクォーターがDBにある場合、レコードが増えないこと' do
      today = Date.new(2019, 9, 4)
      Quarter.create!(
        period: 40,
        ordinal: 1,
        start_date: Date.new(2019, 8, 1),
        end_date: Date.new(2019, 10, 31)
      )
      expect { Quarter.current_quarter(today) }.to_not change(Quarter, :count)
    end

    it 'すでに今日のクォーターがDBにない場合、レコードが増えること' do
      today = Date.new(2019, 9, 4)
      expect { Quarter.current_quarter(today) }.to change(Quarter, :count).by(1)
    end
  end

  describe '#cover_today?' do
    before '40期第2Qのときに実行する' do
      # 現在日時を固定
      travel_to Date.new(2019, 11, 1)
    end

    subject { quarter.cover_today? }

    context '40期第2Qの場合' do
      let(:quarter) { build(:quarter, period: 40, ordinal: 2, start_date: Date.new(2019, 11, 1), end_date: Date.new(2020, 1, 31)) }

      it { is_expected.to be true }
    end

    context '40期第1Qの場合' do
      let(:quarter) { build(:quarter, period: 40, ordinal: 1, start_date: Date.new(2019, 8, 1), end_date: Date.new(2019, 10, 31)) }

      it { is_expected.to be false }

  describe '.find_or_create_quarter' do
    subject { Quarter.find_or_create_quarter('2019-11-14') }

    context 'すでにQuarterがある場合' do
      before do
        create(:quarter, period: 40, ordinal: 2, start_date: Date.new(2019, 11, 1), end_date: Date.new(2020, 1, 31))
      end

      it 'すでにあるQuarterが返されること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 2,
          start_date: Date.new(2019, 11, 1),
          end_date: Date.new(2020, 1, 31)
        )
      end

      it 'Quarterのレコード数が増えないこと' do
        expect { subject }.not_to change { Quarter.count }
      end
    end

    context 'まだQuarterがない場合' do
      it '新しくQuarterがつくられて返されること' do

      end
    end
  end
end
