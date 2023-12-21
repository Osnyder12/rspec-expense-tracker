require 'sinatra/base'
require 'json'
require_relative 'ledger'
require 'nokogiri'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      if request.content_type == 'application/json'
        expense = JSON.parse(request.body.read)
        result = @ledger.record(expense)
      elsif request.content_type == 'text/xml'
        parsed_xml = Nokogiri::XML(request.body)
        expense = {
          'payee' => parsed_xml.xpath("//payee").children.text,
          'amount' => parsed_xml.xpath("//amount").children.text,
          'date' => parsed_xml.xpath("//date").children.text
        }
        result = @ledger.record(expense)
      end

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate(@ledger.expenses_on(params[:date]))
    end
  end
end
