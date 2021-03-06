require 'rails_helper'

RSpec.describe Lunch, type: :model do
  it '同じクォーターの中で同じ組み合わせがあると、有効ではないこと' do
    members = [
      create(:member, real_name: '鈴木一郎'),
      create(:member, real_name: '鈴木二郎'),
      create(:member, real_name: '鈴木三郎')
    ]

    login_user = create(:user)
    create_lunch(members, login_user, date: Date.new(2019, 9, 15))

    lunch = build_lunch(members, login_user, date: Date.new(2019, 9, 16))

    expect(lunch).not_to be_valid
    expect(lunch.errors.messages[:went_to_lunch_with_same_members]).to eq ['鈴木一郎,鈴木二郎,鈴木三郎は2019-09-15にランチ済みです']
  end
end
