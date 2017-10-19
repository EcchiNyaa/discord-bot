module Nyaa
  module Commands
    module Stats
      extend Discordrb::Commands::CommandContainer

      command(:stats, description: "Info; Mostra estatísticas coletadas.") do |event|
        Nyaa::Database::Stat.find(server_id: event.server.id).show
      end
    end
  end
end
