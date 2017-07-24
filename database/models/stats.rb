module Cygnus
  module Database
    STATS = Sequel.connect("sqlite://#{DIR_DB}/stats.db")

    Sequel.extension :migration
    Sequel::Migrator.run STATS, "#{DIR_DB}/migrations/stats"

    class Stats < Sequel::Model STATS[:stats]
      def validate
        self.updated_on = Time.now
      end

      def show
        msg = []
        msg << "**Mensagens analisadas:** #{messages}."
        msg << "**Comandos efetuados:** #{commands}."
        msg << "**Último evento:** #{updated_on.strftime( "%d/%m/%Y %H:%M" )}."

        msg.join "\n"
      end
    end
  end
end
