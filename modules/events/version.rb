module Cygnus
  module Cygnus_Events
    # MÓDULO DE VERSÃO
    # Exibe a versão do repositório local.
    module Version
      extend Discordrb::EventContainer

      mention do |event|
        version = `cd #{DIR} && git log -1 --format="%h (%ar)"`.strip
        ram = ( `ps -o rss= -p #{Process.pid}`.to_i / 1024 ).to_s + " MB"

        replace = [ ["hours ago", "horas atrás"], ["minutes ago", "minutos atrás"], ["seconds ago", "segundos atrás"] ]
        replace.each { |tl| version.gsub!( tl[0], tl[1] ) }

        msg = []
        msg << "__**NYAA**__\n"
        msg << "**VERSÃO:** #{version}."
        msg << "**SOURCE:** [Github](https://github.com/EcchiNyaa/discord-bot/)."
        msg << "**RAM:** #{ram}."

        event.channel.send_embed do |embed|
          embed.description = msg.join( "\n" )
          embed.thumbnail = { url: event.server.member( CONFIG["client_id"] ).avatar_url }
          embed.color = "609af7"
        end
      end
    end
  end
end
