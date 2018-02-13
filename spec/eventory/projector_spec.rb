class TestProjector < Eventory::Projector
  subscription_options processor_name: 'procname'

  table :test_table do
    column :sequence_id, 'SERIAL PRIMARY KEY', unique: true
    column :item_id, 'INT NOT NULL'
  end

  on ItemAdded do |event|
    table(:test_table).insert(item_id: event.data.item_id)
  end
end

RSpec.describe Eventory::Projector do
  subject(:test_projector) { TestProjector.new(event_store: event_store, checkpoints: checkpoints, database: database, version: version) }
  let(:event_store) { Eventory::EventStore.new(database: database) }
  let(:checkpoints) { Eventory::Checkpoints.new(database: database) }
  let(:namespace) { 'ns' }
  let(:version) { 2 }

  context 'schema migrations' do
    it 'creates given tables on up' do
      test_projector.up
      expect(database.table_exists?(:procname_2_test_table)).to eq true
    end

    it 'removes tables on down' do
      test_projector.up
      test_projector.down
      expect(database.table_exists?(:procname_2_test_table)).to eq false
    end
  end

  it 'handles events' do
    test_projector.up
    test_projector.process(recorded_event(type: 'ItemAdded', data: ItemAdded.new(item_id: 1)))
    expect(database[:procname_2_test_table].all.first[:item_id]).to eq 1
  end

  it 'tracks positions' do
    checkpoint = checkpoints.checkout(processor_name: 'procname')
    test_projector.up
    test_projector.process(recorded_event(type: 'ItemAdded', data: ItemAdded.new(item_id: 1)))
    expect(checkpoint.position).to eq 1
    test_projector.process(recorded_event(type: 'ItemAdded', data: ItemAdded.new(item_id: 2)))
    expect(checkpoint.position).to eq 2
  end
end
