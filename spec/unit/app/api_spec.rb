require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    xml = "<?xml version='1.0'?> <rss version='2.0' xmlns:g='http://base.google.com/ns/1.0'><ledger><some>data</some></ledger></rss>"

    def parsed(last_response)
      JSON.parse(last_response.body)
    end

    describe 'POST /expenses in JSON format' do
      let(:expense) { { 'some' => 'data' } }

      before do
        header 'CONTENT-Type', 'application/json'

        allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(true, 417, nil))
      end

      context 'when the expense is successfully recorded' do
        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          expect(parsed(last_response)).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let (:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(parsed(last_response)).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'POST /expenses in XML format' do
      let(:expense) { { "payee"=>"", "amount"=>"", "date"=>"" } }

      before do
        header 'CONTENT-Type', 'text/xml'

        allow(ledger).to receive(:record)
          .with(expense)
          .and_return(RecordResult.new(true, 417, nil))
      end

      context 'when expense is successfully recorded' do
        it 'returns the expense id' do
          post '/expenses', xml

          expect(parsed(last_response)).to include('expense_id' => 417)
        end
      end
    end

    describe '/expenses/:date' do
      let(:date) { 'date' }
      
      context 'when the expenese exist on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with(date)
            .and_return([{'payee' => 'Zoo', 'amount' => 15.25, 'date' => '2017-06-10'}])
        end

        it 'returns the expense records as JSON' do
          get "/expenses/#{date}"

          expect(parsed(last_response).empty?).to be(false)
        end

        it 'responds with a 200 (OK)' do
          get "/expenses/#{date}"

          expect(last_response.status).to be(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with(date)
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          get "/expenses/#{date}"

          expect(parsed(last_response).empty?).to be(true)
        end

        it 'responds with a 200 (OK)' do
          get "/expenses/#{date}"

          expect(last_response.status).to be(200)
        end
      end
    end
  end
end