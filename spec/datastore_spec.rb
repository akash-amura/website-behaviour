# frozen_string_literal: true

require File.expand_path('tracker/datastore')

describe Tracker::Datastore do
  describe '#initialize' do
    context 'google cloud project is defined in environment variable' do
      it 'should create a datastore object of specified kind' do
        datastore = Tracker::Datastore.new('Event')
        expect(datastore.kind).to eq('Event')
      end
    end

    context 'google cloud project is not defined in environment variable' do
      it 'should raise RuntimeError' do
        allow(ENV).to receive(:[]).with('GOOGLE_CLOUD_PROJECT').and_return(nil)
        expect { Tracker::Datastore.new('Event') }.to raise_error(RuntimeError)
      end
    end

    context 'google cloud project defined in the environment variable is incorrect or not defined in the cloud' do
      it 'should raise Google::Cloud::NotFoundError' do
        old_project = ENV['GOOGLE_CLOUD_PROJECT']
        ENV['GOOGLE_CLOUD_PROJECT'] = 'abcd'
        expect { Tracker::Datastore.new('Event') }.to raise_error(Google::Cloud::NotFoundError)
        ENV['GOOGLE_CLOUD_PROJECT'] = old_project
      end
    end
  end

  describe '#insert' do
    before(:each) do
      @datastore = Tracker::Datastore.new('Event')
    end

    context 'given nil in argument' do
      it 'should raise ArgumentError' do
        expect { @datastore.insert(nil) }.to raise_error(ArgumentError)
      end
    end

    context 'given any other argument other than Hash' do
      it 'should raise ArgumentError for Array' do
        expect { @datastore.insert([]) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for Integer' do
        expect { @datastore.insert(5) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for Boolean' do
        expect { @datastore.insert(true) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for Symbol' do
        expect { @datastore.insert(:abc) }.to raise_error(ArgumentError)
      end

      it 'should raise ArgumentError for String' do
        expect { @datastore.insert('abcd') }.to raise_error(ArgumentError)
      end
    end

    context 'given a valid hash object' do
      it 'should return false if unable to save' 

      it 'should return the entity if saved successfully' do
        entity = @datastore.insert(event_name: 'page_viewed', client_id: 100, lead_id: 200)
        expect(entity).to be_an_instance_of(Google::Cloud::Datastore::Entity)
      end
    end
  end

  describe '#query' do
    before(:each) do
      @datastore = Tracker::Datastore.new('Event')
    end

    context 'no block given to the query method' do
      it 'should raise ArgumentError' do
        expect{ @datastore.query }.to raise_error(ArgumentError)
      end
    end

    context 'given a invalid block to the query method' do
      it 'should raise NoMethodError when a unknown method is used in block' do
        expect{ @datastore.query{ |q| q.abc } }.to raise_error(NoMethodError)
      end

      it 'should raise ArgumentError when block does not expect a argument' do
        expect{ @datastore.query{ puts 'abc' } }.to raise_error(ArgumentError)
      end
    end
  end
end
