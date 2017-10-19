module Nyaa
  module Commands
    module Ping
      extend Discordrb::Commands::CommandContainer

      command(:ping,
        description: "Info; Informa o tempo de resposta entre o servidor e discord.") do |event|

        ping = ((Time.now - event.timestamp) * 1000).round

        event.channel.send_embed do |e|
          e.title = "Pong!"
          e.description = "Tempo de resposta: #{ping}ms."
          e.color = "9370DB"
        end
      end
    end
  end
end
