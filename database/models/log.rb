module Cygnus
  module Database
    LOG = Sequel.connect("sqlite://#{DIR_DB}/logs.db")

    Sequel.extension :migration
    Sequel::Migrator.run LOG, "#{DIR_DB}/migrations/logs"

    class Afastamento < Sequel::Model LOG[:afastamentos]
      def transparency
        msg = []
        msg << "**Ocorrência nº ##{id}**"
        msg << "**Membro #{status}**."
        msg << "**Usuário:** #{user}."
        msg << "**Moderador:** #{mod}."
        msg << "**Razão:** #{reason}."

        channel = BOT.server( server_id ).channels.find { |ch| ch.id == CONFIG["transparency_channel_id"] }
        channel.send_message msg.join "\n" if channel
      end
    end

    class Evento < Sequel::Model LOG[:eventos]; end
  end
end
