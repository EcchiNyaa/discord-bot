module Cygnus
  module Cygnus_Commands
    # ESTATÍSTICAS
    # Mostra estatísticas sobre o bot.
    module Stats
      extend Discordrb::Commands::CommandContainer

      command :stats, help_available: false do |event|
        Cygnus::Database::Stats.where( server_id: event.server.id ).first.show
      end
    end
  end
end
