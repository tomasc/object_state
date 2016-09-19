require 'test_helper'

describe ObjectState::State do
  describe '.setup_attributes' do
    let(:state_class) { Class.new(ObjectState::State) }
    let(:state) { state_class.new(model) }

    describe 'PoRo' do
      let(:model) { PoRoDoc.new }

      before do
        state_class.setup_attributes(model.class) do
          attr_accessor :current_date
        end
      end

      it 'must create attribute' do
        state.class.attribute_set['current_date'].must_be :present?
        state.class.attribute_set['current_date'].primitive.must_equal BasicObject
      end
    end

    describe 'Mongoid fields' do
      let(:model) { MongoidDoc.new }

      before do
        state_class.setup_attributes(model.class) do
          field :title, type: String
        end
      end

      it 'must create attribute' do
        state.class.attribute_set['title'].must_be :present?
        state.class.attribute_set['title'].primitive.must_equal String
      end
    end

    describe 'Virtus attributes' do
      let(:model) { VirtusDoc.new }

      before do
        state_class.setup_attributes(model.class) do
          attribute :number, Integer
        end
      end

      it 'must create attribute' do
        state.class.attribute_set['number'].must_be :present?
        state.class.attribute_set['number'].primitive.must_equal Integer
      end
    end
  end

  # ---------------------------------------------------------------------

  describe '#initialize' do
    let(:model) { PoRoDoc.new }
    let(:state) { model.object_state }
    it { state.model.must_equal model }
  end

  describe '#update_model' do
    describe 'PoRo' do
      let(:current_date) { Date.today }
      let(:date_tomorrow) { Date.tomorrow }
      let(:model) { PoRoDoc.new(current_date) }
      let(:state) { model.object_state }

      it 'assigns attributes from state to model' do
        state.current_date = date_tomorrow
        state.update_model!
        model.current_date.must_equal date_tomorrow
      end
    end

    describe 'Mongoid' do
      let(:title) { 'Foo' }
      let(:new_title) { 'Bar' }
      let(:model) { MongoidDoc.new(title: title) }
      let(:state) { model.object_state }

      it 'assigns attributes from state to model' do
        state.title = new_title
        state.update_model!
        model.title.must_equal new_title
      end
    end

    describe 'Virtus' do
      let(:number) { 1 }
      let(:new_number) { 2 }
      let(:model) { VirtusDoc.new(number: number) }
      let(:state) { model.object_state }

      it 'assigns attributes from state to model' do
        state.number = new_number
        state.update_model!
        model.number.must_equal new_number
      end
    end
  end

  describe '#to_hash' do
    describe 'PoRo' do
      let(:current_date) { Date.today }
      let(:date_tomorrow) { Date.tomorrow }
      let(:model) { PoRoDoc.new(current_date) }
      let(:state) { model.object_state }

      it { state.to_hash.must_equal(model.class.to_s.underscore => { current_date: current_date }) }

      describe 'with attr overrides' do
        it { state.to_hash(current_date: date_tomorrow).must_equal(model.class.to_s.underscore => { current_date: date_tomorrow }) }
      end
    end

    describe 'Mongoid' do
      let(:title) { 'Foo' }
      let(:new_title) { 'Bar' }
      let(:model) { MongoidDoc.new(title: title) }
      let(:state) { model.object_state }

      it { state.to_hash.must_equal(model.model_name.singular => { id: model.id, title: title }) }

      describe 'with attr overrides' do
        it { state.to_hash(title: new_title).must_equal(model.model_name.singular => { id: model.id, title: new_title }) }
      end
    end

    describe 'Virtus' do
      let(:number) { 1 }
      let(:new_number) { 2 }
      let(:model) { VirtusDoc.new(number: number) }
      let(:state) { model.object_state }

      it { state.to_hash.must_equal(model.class.to_s.underscore => { number: number }) }

      describe 'with attr overrides' do
        it { state.to_hash(number: new_number).must_equal(model.class.to_s.underscore => { number: new_number }) }
      end
    end
  end

  describe '#cache_key' do
    describe 'PoRo' do
      let(:current_date) { Date.today }
      let(:model) { PoRoDoc.new(current_date) }
      let(:state) { model.object_state }

      it 'calculates :cache_key' do
        state.cache_key.must_equal [current_date].map(&:to_s).join('/')
      end
    end

    describe 'Mongoid' do
      let(:title) { 'Foo' }
      let(:model) { MongoidDoc.new(title: title) }
      let(:state) { model.object_state }

      it 'calculates :cache_key' do
        state.cache_key.must_equal [title].map(&:to_s).join('/')
      end
    end

    describe 'Virtus' do
      let(:number) { 1 }
      let(:model) { VirtusDoc.new(number: number) }
      let(:state) { model.object_state }

      it 'calculates :cache_key' do
        state.cache_key.must_equal [number].map(&:to_s).join('/')
      end
    end
  end
end
