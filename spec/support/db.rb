RSpec.configure do |c|
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations')
    DB[:expenses].truncate
    FileUtils.mkdir_p('log')
    require 'logger'
    DB.loggers << Logger.new('log/sequel.log')
    # c.define_derived_metadata do |meta|
    #   DB.loggers << Logger.new(meta[:description])
    # end
  end

  c.around(:example, :db) do |example|
    DB.transaction(rollback: :always) { example.run }
  end
end