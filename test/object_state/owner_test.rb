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

    describe '#assign_attributes_from_state_hash' do
      let(:date_tomorrow) { Date.tomorrow }
      let(:attrs) { { model.class.to_s.underscore => { current_date: date_tomorrow } } }

      it 'assigns the attributes' do
        model.assign_attributes_from_state_hash(attrs)
        model.current_date.must_equal date_tomorrow
      end
    end

    describe '#to_object_state_hash' do
      it { model.must_respond_to :to_object_state_hash }
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

    describe '#cache_key' do
      it 'includes state :cache_key' do
        model.cache_key.must_include model.object_state.cache_key
      end
    end

    describe '#assign_attributes_from_state_hash' do
      let(:new_title) { 'Bar' }
      let(:attrs) { { model.model_name.singular => { id: model.id, title: new_title } } }

      it 'assigns the attributes' do
        model.assign_attributes_from_state_hash(attrs)
        model.title.must_equal new_title
      end

      describe 'when id not found' do
        let(:attrs) { { model.model_name.singular => { id: 'non-matching', title: new_title } } }

        it 'does not assign state' do
          model.assign_attributes_from_state_hash(attrs)
          model.title.wont_equal new_title
        end
      end
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

    describe '#assign_attributes_from_state_hash' do
      let(:new_number) { number + 1 }
      let(:attrs) { { model.class.to_s.underscore => { number: new_number } } }

      it 'assigns the attributes' do
        model.assign_attributes_from_state_hash(attrs)
        model.number.must_equal new_number
      end
    end
  end

  describe 'custom State Class' do
    let(:title) { 'Foo' }
    let(:model) { CustomStateOwner.new(title: title) }

    describe '#object_state' do
      it { model.object_state.must_be_kind_of CustomStateOwner::State }
      it { model.object_state.title.must_equal title.downcase }
    end
  end

  describe 'multiple object_state blocks' do
    let(:model) { MultipleObjectStateOwner.new }

    describe '#object_state' do
      it { model.object_state.must_respond_to :title }
      it { model.object_state.must_respond_to :number }
    end
  end
end
