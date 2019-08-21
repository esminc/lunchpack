require 'rails_helper'

describe Lunch do
  it '3人のメンバーが選ばれていないと有効ではないこと' do
    member1 = create(:member, real_name: '鈴木一郎')
    member2 = create(:member, real_name: '鈴木二郎')
    lunch = build(:lunch, members: [member1, member2])
    expect(lunch).to_not be_valid
  end

  describe 'scope' do
    it 'in_current_quarter' do
      member1 = create(:member, real_name: '鈴木一郎')
      member2 = create(:member, real_name: '鈴木二郎')
      member3 = create(:member, real_name: '鈴木三郎')
      create(:lunch, members: [member1, member2, member3])
      create(:lunch, date: Date.today.next_year, members: [member1, member2, member3])
      expect(Lunch.count).to eq 2
      expect(Lunch.in_current_quarter.count).to eq 1
    end
  end
end
