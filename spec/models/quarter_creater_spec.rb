require 'rails_helper'

RSpec.describe QuarterCreater, type: :model do
  describe '#create_quarter!' do
    subject { described_class.new(date).create_quarter! }

    context '2019/8/1の場合' do
      let(:date) { Date.new(2019, 8, 1) }

      it '40期の第1クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 1,
          start_date: Date.new(2019, 8, 1),
          end_date: Date.new(2019, 10, 31)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end

    context '2019/10/31の場合' do
      let(:date) { Date.new(2019, 10, 31) }

      it '40期の第1クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 1,
          start_date: Date.new(2019, 8, 1),
          end_date: Date.new(2019, 10, 31)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end

    context '2019/11/1の場合' do
      let(:date) { Date.new(2019, 11, 1) }

      it '40期の第2クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 2,
          start_date: Date.new(2019, 11, 1),
          end_date: Date.new(2020, 1, 31)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end

    context '2020/2/1の場合' do
      let(:date) { Date.new(2020, 2, 1) }

      it '40期の第3クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 3,
          start_date: Date.new(2020, 2, 1),
          end_date: Date.new(2020, 4, 30)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end

    context '2020/5/1の場合' do
      let(:date) { Date.new(2020, 5, 1) }

      it '40期の第4クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 40,
          ordinal: 4,
          start_date: Date.new(2020, 5, 1),
          end_date: Date.new(2020, 7, 31)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end

    context '2020/8/1の場合' do
      let(:date) { Date.new(2020, 8, 1) }

      it '41期の第1クウォーターが作られること' do
        expect(subject).to have_attributes(
          period: 41,
          ordinal: 1,
          start_date: Date.new(2020, 8, 1),
          end_date: Date.new(2020, 10, 31)
        ).and be_an_instance_of(Quarter)
      end

      it 'Quarterのレコード数が増えること' do
        expect { subject }.to change { Quarter.count }.by(1)
      end
    end
  end
end
