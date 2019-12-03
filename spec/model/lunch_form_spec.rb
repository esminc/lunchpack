require 'rails_helper'

RSpec.describe LunchForm do
  describe '#must_have_benefits_available_count_members' do
    let(:lunch_form_params) { {date: '2019-11-21', members: members} }

    subject { described_class.new(lunch_form_params) }

    context '3 人指定されているとき' do
      let(:members) { ['111', 'bbb','ccc'] }

      it { is_expected.to be_valid }
    end

    context '2 人指定されているとき' do
      let(:members) { ['111', 'bbb'] }

      it { is_expected.not_to be_valid }
    end
  end
end
