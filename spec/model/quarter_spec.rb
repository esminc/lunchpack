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
end
