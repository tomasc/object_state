require 'test_helper'

describe ObjectState::Owner do
  describe 'PoRo' do
    let(:current_date) { Date.today }
    let(:model) { PoRoDoc.new(current_date) }

    it 'must preserve the original attributes' do
      model.must_respond_to :current_date
    end

    describe '#object_state' do
      it { model.object_state.must_be_kind_of ObjectState::State }
      it { model.object_state.current_date.must_equal current_date }
    end
  end

  describe 'Mongoid' do
    let(:title) { 'Foo' }
    let(:model) { MongoidDoc.new(title: title) }

    it 'must preserve the original attributes' do
      model.must_respond_to :title
    end

    describe '#object_state' do
      it { model.object_state.must_be_kind_of ObjectState::State }
      it { model.object_state.title.must_equal title }
    end
  end

  describe 'Virtus' do
    let(:number) { 1 }
    let(:model) { VirtusDoc.new(number: number) }

    it 'must preserve the original attributes' do
      model.must_respond_to :number
    end

    describe '#object_state' do
      it { model.object_state.must_be_kind_of ObjectState::State }
      it { model.object_state.number.must_equal number }
    end
  end
end
