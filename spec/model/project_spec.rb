require 'rails_helper'

describe Project do
  it '名前がないと有効でないこと' do
    project = Project.new(name: '')
    expect(project).to_not be_valid
  end
end
