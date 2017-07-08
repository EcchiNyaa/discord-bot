module Cygnus
  module Cygnus_Commands
    # PRUNE
    # Apaga mensagens de acordo com o filtro.
    module Prune
      extend Discordrb::Commands::CommandContainer

      # Apaga certo número de mensagens.
      command :rm, help_available: false, required_permissions: [:administrator] do |event, num|
        ( event << "\\⚠ :: !rm [2-100]"; break ) unless num
        ( event << "\\⚠ :: Não está entre o intervalo permitido."; break ) unless num.to_i >= 2 && num.to_i <= 100
        break unless event.bot.profile.on( event.server ).can_manage_messages?

        event.channel.prune( num.to_i )
      end

      # Retrocede até certa mensagem.
      command :retroceder, help_available: false, required_permissions: [:administrator] do |event, id|
        ( event << "\\⚠ :: !retroceder (até) [id]"; break ) unless id
        ( event << "\\⚠ :: Número fornecido não parece um ID."; break ) unless id.length = 18
        break unless event.bot.profile.on( event.server ).can_manage_messages?

        msg = event.channel.history( 100 ).take_while { |h| h.id != id.to_i }
        event.channel.delete_messages msg
      end

      # Deleta mensagens de um usuário dentro de um certo intervalo.
      command :prune, help_available: false, required_permissions: [:administrator] do |event, num|
        ( event << "\\⚠ :: !prune [2-100] [usuário]"; break ) unless event.message.mentions.empty? || num
        ( event << "\\⚠ :: Não está entre o intervalo permitido."; break ) unless num.to_i >= 2 && num.to_i <= 100
        break unless event.bot.profile.on( event.server ).can_manage_messages?

        msg = []
        event.channel.history( num.to_i ).count do |h|
          msg.push h if h.author.id == event.message.mentions.first.on( event.server ).id
        end

        event.channel.delete_messages msg
      end
    end
  end
end
