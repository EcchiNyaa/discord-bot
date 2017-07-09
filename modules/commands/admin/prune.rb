module Cygnus
  module Cygnus_Commands
    # PRUNE
    # Apaga mensagens de acordo com o filtro.
    module Prune
      extend Discordrb::Commands::CommandContainer

      # Apaga certo número de mensagens.
      command :rm, help_available: false, required_permissions: [:manage_messages], permission_message: false do |event, num|
        next "\\⚠ :: !rm [2-100]" unless num
        next "\\⚠ :: Não está entre o intervalo permitido." unless num.to_i >= 2 && num.to_i <= 100

        event.channel.prune( num.to_i )

        msg = "Prunou #{num.to_i} mensagens de ##{event.channel.name}."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: msg

        return nil
      end

      # Retrocede até certa mensagem.
      command :retroceder, help_available: false, required_permissions: [:manage_messages], permission_message: false do |event, id|
        next "\\⚠ :: !retroceder (até) [id]" unless id
        next "\\⚠ :: Número fornecido não parece um ID." unless id.length == 18

        msg = event.channel.history( 100 ).take_while { |h| h.id != id.to_i }
        event.channel.delete_messages msg

        log = "Retrocedeu #{msg.length} mensagens de ##{event.channel.name}."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: log

        return nil
      end

      # Deleta mensagens de um usuário dentro de um certo intervalo.
      command :prune, help_available: false, required_permissions: [:manage_messages], permission_message: false do |event, num|
        next "\\⚠ :: !prune [2-100] [usuário]" if event.message.mentions.empty? || ! num
        next "\\⚠ :: Não está entre o intervalo permitido." unless num.to_i >= 2 && num.to_i <= 100

        user = event.message.mentions.first.on( event.server )

        msg = []
        event.channel.history( num.to_i ).count do |h|
          msg.push h if h.author.id == user.id
        end

        event.channel.delete_messages msg

        log = "Prunou #{msg.length} mensagens de #{user.distinct} em ##{event.channel.name}."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: log

        return nil
      end
    end
  end
end
