require 'test_helper'

describe ObjectState::State do
  let(:current_date) { Date.today }
  let(:model) { MyDoc.new(current_date: current_date) }
  subject { ObjectState::State.new(model) }

  it { subject.must_respond_to :model }

  describe '.setup_attributes' do
    describe 'attr_accessor' do
      before do
        ObjectState::State.setup_attributes do
          attr_accessor :current_date
        end
      end

      it 'must create String attribute' do
        subject.class.attribute_names.must_equal [:current_date]
      end
    end

    describe 'Mongoid fields' do

    end

    describe 'Virtus attributes' do

    end
  end

  describe '#initialize' do
    it { subject.model.must_equal model }
  end

  describe '#update_model' do
  end

  describe '#to_hash' do
  end

  describe '#cache_key' do
  end
end
