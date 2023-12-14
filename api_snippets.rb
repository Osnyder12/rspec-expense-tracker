class API < Sinatra::Base
  def initialize(ledger:)
    @ledger = ledger
    super()
end