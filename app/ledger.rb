require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      unless expense.keys.sort == ['amount', 'date', 'payee']
        keys = expense.keys
        required = ['payee', 'date', 'amount']
        result = (keys - required) + (required - keys)
        message = "Invalid expense: #{result.join(', ')} is required"

        return RecordResult.new(false, nil, message)
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end