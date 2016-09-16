require 'test_helper'

describe ObjectState::State do
  let(:current_date) { Date.today }
  let(:model) { MyDoc.new(current_date: current_date) }
  subject { ObjectState::State.new(model) }

  it { subject.must_respond_to :model }

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
