require_relative '../../../app/ledger' # ledger class
require_relative '../../../config/sequel' # db load
require_relative '../../support/db' # migrations and db clearing

module ExpenseTracker
  RSpec.describe Ledger do
    let(:ledger) { Ledger.new }
    let(:expense) do
      {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }
    end

    describe '#record' do
    # context
    end
  end
end
