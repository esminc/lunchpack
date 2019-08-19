require 'rails_helper'

describe Member do
  before do
    create(:member, email: 'sample@esm.co.jp')
  end

  it 'メールアドレスの重複は有効ではないか' do
    member = Member.new(hundle_name: 'yama', real_name: '山本太郎', email: 'sample@esm.co.jp')
    expect(member).to_not be_valid
  end
end
