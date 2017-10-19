module Nyaa
  module Database
    class Ban < Sequel::Model
      plugin :enum
      enum   :event, [:ban, :kick, :unban]

      def template( msg )
        msg << "**Ocorrência nº ##{id}**"
        msg << "**Membro #{event}**."
        msg << "**Usuário:** #{user}."
        msg << "**Moderador:** #{moderator}."
        msg << "**Razão:** #{reason}.\n"
      end

      def show
        msg = []
        template msg
      end

      def transparency
        msg = []
        msg = template msg

        channel = BOT.server(server_id).channels.find { |ch| ch.id == CONFIG["transparency_channel_id"] }
        channel.send_message msg.join "\n" if channel
      end
    end
  end
end
