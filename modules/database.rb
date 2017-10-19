require "sequel"
require "sequel_enum"

module Nyaa
  module Database
    DB = Sequel.connect("sqlite://database/nyaa.db")

    Sequel.extension :migration
    Sequel::Migrator.run(DB, "database/migrations")

    Sequel::Model.plugin :timestamps

    Dir["database/models/*.rb"].each { |model| load model }
  end
end
