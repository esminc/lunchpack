require 'rails_helper'

RSpec.describe ProjectDecorator do
  describe '#delete_confirm' do
    subject { project.delete_confirm }

    let(:project) { Project.new(name: 'eiwakun').extend described_class }

    context '所属メンバーがいる場合' do
      before do
        create(:member, real_name: '永和太郎', projects: [project])
      end

      it { is_expected.to eq 'eiwakunには永和太郎が所属しています。eiwakunを削除しますか？' }
    end

    context '所属メンバーがいない場合' do
      it { is_expected.to eq 'eiwakunを削除しますか？' }
    end
  end
end
