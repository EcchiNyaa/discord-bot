require "sequel"
require "sqlite3"

module Cygnus
  module Database
    # Inlui cada modelo de DB.
    #
    # ------ EXEMPLO ------
    #
    # NOME = Sequel.connect("sqlite://#{DIR_DB}/nome.db")
    #
    # Sequel.extension :migration
    # Sequel::Migrator.run NOME, "#{DIR_DB}/migrations/nome"

    Sequel::Model.raise_on_save_failure = false

    Dir["#{DIR_DB}/models/*.rb"].each { |file| require file }
  end
end
