module Cygnus
  module Cygnus_Events
    # MÓDULO DE JOIN / PART
    # Anuncia no canal definido em config.yml o fluxo de entrada e saida do servidor..
    module Join_Announcer
      extend Discordrb::EventContainer

      member_join do |event|
        time = ( Time.now - event.user.creation_time ) / 86400.0
        event.bot.channel( CONFIG["join_part_channel_id"] ).send_embed do |embed|
          msg = []
          msg << "**#{event.user.distinct.capitalize} [ #{event.user.mention} ] entrou!**"
          msg << "**Conta criada há #{time.ceil} dias.**"
          embed.footer = { text: "ID: #{event.user.id}." }
          embed.description = msg.join "\n"
          embed.color = "2E8B57"
        end
      end

      member_leave do |event|
        event.bot.channel( CONFIG["join_part_channel_id"] ).send_embed do |embed|
          embed.description = "**#{event.user.distinct.capitalize} [ #{event.user.mention} ] deixou o servidor!**"
          embed.footer = { text: "ID: #{event.user.id}." }
          embed.color = "B22222"
        end
      end
    end
  end
end
