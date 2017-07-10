module Cygnus
  module Database
    IMOUTO = Sequel.connect("sqlite://#{DIR_DB}/imouto.db")

    Sequel.extension :migration
    Sequel::Migrator.run IMOUTO, "#{DIR_DB}/migrations/imouto"

    class ImoutoUser < Sequel::Model IMOUTO[:users]
      def validate
        return if updated_on.nil?

        seconds_passed = Time.now - updated_on
        interval = 4 * 3600
        errors.add :created_on, "Intervalo mínimo de 4 horas!" unless seconds_passed > interval
      end

      def after_validation
        self.updated_on = Time.now
      end
    end
  end
end
