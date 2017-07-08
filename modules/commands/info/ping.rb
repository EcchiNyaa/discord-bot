module Cygnus
  module Cygnus_Commands
    # STATUS
    # Mostra informações sobre o bot.
    module Ping
      extend Discordrb::Commands::CommandContainer

      command :ping, help_available: false do |event|
        event << event.user.mention + " #{( (Time.now - event.timestamp) * 1000 ).to_i} ms."
      end
    end
  end
end
