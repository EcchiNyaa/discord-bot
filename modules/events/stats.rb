module Cygnus
  module Cygnus_Events
    # MÓDULO DE ESTATÍSTICAS
    # Exibe as estatísticas do servidor, como total de comandos efetuados e mensagens por dia.
    module Stats
      extend Discordrb::EventContainer

      ready do |event|
        event.bot.servers.values.map(&:id).each do |server|
          db = Cygnus::Database::Stats
          next unless db.where( server_id: server ).count.zero?

          db.create( server_id: server )
        end
      end

      message do |event|
        db = Cygnus::Database::Stats.where( server_id: event.server.id ).first
        db.messages += 1
        db.save

        next unless event.message.content.start_with? CONFIG["prefix"]

        db.commands += 1
        db.save
      end
    end
  end
end
