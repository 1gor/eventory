RSpec.describe PostgresEventStore::Checkpoint do
  let(:checkpoint_1) { PostgresEventStore::Checkpoint.new(database: database, name: 'name-1') }
  let(:checkpoint_2) { PostgresEventStore::Checkpoint.new(database: database, name: 'name-2') }

  it "defaults to 0 when a checkpoint isn't saved" do
    expect(checkpoint_1.position).to eq 0
  end

  it 'saves checkpoints to the database' do
    checkpoint_1.save_position(3)
    checkpoints = database[:checkpoints].all
    expect(checkpoints.count).to eq 1
    expect(checkpoints.first[:name]).to eq 'name-1'
    expect(checkpoints.first[:position]).to eq 3
  end

  it 'saves checkpoints to given positions' do
    checkpoint_1.save_position(2)
    checkpoint_2.save_position(10)
    expect(checkpoint_1.position).to eq 2
    expect(checkpoint_2.position).to eq 10
    checkpoint_2.save_position(11)
    expect(checkpoint_1.position).to eq 2
    expect(checkpoint_2.position).to eq 11
  end
end
