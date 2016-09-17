require 'test_helper'

describe ObjectState::Owner do
  describe 'PORO class' do
    let(:current_date) { Date.today }
    let(:tomorrow_date) { Date.tomorrow }
    subject { MyDoc.new(current_date) }

    it 'must preserve the original attributes' do
      subject.must_respond_to :current_date
    end

    describe '#object_state' do
      it { subject.object_state.must_be_kind_of ObjectState::State }
      it { subject.object_state.current_date.must_equal subject.current_date }
    end
  end

  describe 'Virtus class' do
  end

  describe 'Mongoid class' do
  end

  describe 'custom State class' do
  end
end
