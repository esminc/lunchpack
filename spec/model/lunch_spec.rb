require 'rails_helper'

describe Lunch do
  it '3人のメンバーが選ばれていないと有効ではないこと' do
    member1 = create(:member, real_name: '鈴木一郎')
    member2 = create(:member, real_name: '鈴木二郎')
    lunch = build(:lunch, members: [member1, member2])
    expect(lunch).to_not be_valid
  end

  describe 'scope' do
    describe 'in_current_quarter' do
      let(:member1) { create(:member, real_name: '鈴木一郎') }
      let(:member2) { create(:member, real_name: '鈴木二郎') }
      let(:member3) { create(:member, real_name: '鈴木三郎') }

      it '今日行ったランチは含まれること' do
        today_lunch = create(:lunch, members: [member1, member2, member3])
        expect(Lunch.in_current_quarter).to include today_lunch
      end

      it '3ヶ月前行ったランチは含まれないこと' do
        three_month_ago_lunch = create(:lunch, date: Date.today.prev_month(3), members: [member1, member2, member3])
        expect(Lunch.in_current_quarter).to_not include three_month_ago_lunch
      end

      it '去年行ったランチは含まれないこと' do
        last_year_lunch = create(:lunch, date: Date.today.last_year, members: [member1, member2, member3])
        expect(Lunch.in_current_quarter).to_not include last_year_lunch
      end
    end
  end
end
