module Cygnus
  module Database
    LOG = Sequel.connect("sqlite://#{DIR_DB}/logs.db")

    Sequel.extension :migration
    Sequel::Migrator.run LOG, "#{DIR_DB}/migrations/logs"

    class Afastamento < Sequel::Model LOG[:afastamentos]
      def template( msg )
        msg << "**Ocorrência nº ##{id}**"
        msg << "**Membro #{status}**."
        msg << "**Usuário:** #{user}."
        msg << "**Moderador:** #{mod}."
        msg << "**Razão:** #{reason}.\n"
      end

      def show
        msg = []
        template msg
      end

      def transparency
        msg = []
        msg = template msg

        channel = BOT.server( server_id ).channels.find { |ch| ch.id == CONFIG["transparency_channel_id"] }
        channel.send_message msg.join "\n" if channel
      end

      def self.dump
        msg = []
        self.all do |e|
          msg << "Ocorrência nº ##{e.id}"
          msg << "Membro #{e.status}."
          msg << "Usuário: #{e.user}."
          msg << "Moderador: #{e.mod}."
          msg << "Razão: #{e.reason}.\n"
        end

        File.open( "/tmp/afastamentos.log", "w" ) do |f|
          f.write msg.join( "\n" )
        end

        return "/tmp/afastamentos.log"
      end
    end

    class Evento < Sequel::Model LOG[:eventos]
      def template( msg )
        msg << "**Evento ##{id}**."
        msg << "**Moderador:** #{mod}"
        msg << "**Data:** #{created_on.strftime( "%d/%m/%Y %H:%M" )}"
        msg << "**Evento:** #{log}\n"
      end

      def show
        msg = []
        template msg
      end

      def self.dump
        msg = []
        self.all do |e|
          msg << "Evento ##{e.id}."
          msg << "Moderador: #{e.mod}"
          msg << "Data: #{e.created_on.strftime( "%d/%m/%Y %H:%M" )}"
          msg << "Evento: #{e.log}\n"
        end

        File.open( "/tmp/eventos.log", "w" ) do |f|
          f.write msg.join( "\n" )
        end

        return "/tmp/eventos.log"
      end
    end
  end
end
