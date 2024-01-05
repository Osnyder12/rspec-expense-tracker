require 'pp'

RSpec.describe Hash, :outer_group do
  it 'is used RSpec for metadata', :fast do |example|
    pp example.metadata
  end

  context 'on a nested group' do
    it 'is also inherited' do |example|
      pp example.metadata
    end
  end
end