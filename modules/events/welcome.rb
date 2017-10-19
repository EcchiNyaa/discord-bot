module Nyaa
  module Events
    module Welcome
      extend Discordrb::EventContainer

      member_join do |event|
        time = (Time.now - event.user.creation_time) / 86400.0

        event.bot.channel(CONFIG.welcome.channel).send_embed do |e|
          msg = []

          msg << "**#{event.user.distinct.capitalize} [ #{event.user.mention} ] entrou!**"
          msg << "**Conta criada há #{time.ceil} dias.**"

          e.description = msg.join("\n")
          e.footer = { text: "ID: #{event.user.id}." }
          e.color = "2E8B57"
        end
      end

      member_leave do |event|
        event.bot.channel(CONFIG.welcome_channel).send_embed do |e|
          msg = "**#{event.user.distinct.capitalize} [ #{event.user.mention} ] deixou o servidor!**"

          e.description = msg
          e.footer = { text: "ID: #{event.user.id}." }
          e.color = "B22222"
        end
      end
    end
  end
end
