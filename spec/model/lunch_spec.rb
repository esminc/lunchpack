require 'rails_helper'

describe Lunch do
  it '3人のメンバーが選ばれていないと有効ではないこと' do
    member1 = create(:member, real_name: '鈴木一郎')
    member2 = create(:member, real_name: '鈴木二郎')
    lunch = build(:lunch, members: [member1, member2])
    expect(lunch).to_not be_valid
  end
end
