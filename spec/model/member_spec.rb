require 'rails_helper'

describe Member do
  it 'メールアドレスの重複は有効ではないこと' do
    create(:member, email: 'sample@esm.co.jp')
    member = Member.new(handle_name: 'yama', real_name: '山本太郎', email: 'sample@esm.co.jp')
    expect(member).to_not be_valid
  end

  it 'ハンドルネームがないと有効ではないこと' do
    member = Member.new(handle_name: '', real_name: '山田太郎')
    expect(member).to_not be_valid
  end

  it '氏名がないと有効ではないこと' do
    member = Member.new(handle_name: 'yama', real_name: '')
    expect(member).to_not be_valid
  end
end
