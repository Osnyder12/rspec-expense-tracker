RSpec.shared_examples 'KV store' do |kv_store_class|
  let(:kv_store) { kv_store_class.new }

  xit 'allows you to fetch previously stored values' do
    kv_store.store(:language, 'Ruby')
    kv_store.store(:os, 'linuz')

    expect(kv_store.fetch(:language)).to eq 'Ruby'
    expect(kv_store.fetch(:os)).to eq 'linux'
  end

  xit 'raises a KeyError when you fetch an unknown key' do
    expect { kv_store.fetch(:foo) }.to raise_error(KeyError)
  end
end