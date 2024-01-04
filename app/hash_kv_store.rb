require_relative '../config/sequel'

class HashKVStore
  attr_accessor :hash

  def initialize
    @hash = {}
  end

  def fetch(key)
    raise KeyError unless hash.key?(key)

    hash[key]
  end

  def store(key, value)
    hash[key] = value
  end
end