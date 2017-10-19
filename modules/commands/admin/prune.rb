module Nyaa
  module Commands
    module Prune
      extend Discordrb::Commands::CommandContainer

      command(:rm, help_available: false,
              permission_level: 2, permission_message: false) do |event, num|

        next "\\⚠ :: !rm [2-100]" unless num
        next "\\⚠ :: Não está entre o intervalo permitido." unless num.to_i >= 2 && num.to_i <= 100

        event.channel.prune(num.to_i)
        msg = "#{num.to_i} mensagens removidas de ##{event.channel.name}."

        Nyaa::Database::ModLog.create(
          event: :prune,
          description: msg,
          moderator: event.user.distinct,
          moderator_id: event_user.id,
          server_id: event.server.id
        )

        nil
      end

      command(:retroceder, help_available: false,
              permission_level: 2, permission_message: false) do |event, id|

        next "\\⚠ :: !retroceder (até) [id]" unless id
        next "\\⚠ :: Número fornecido não parece um ID." unless id.length == 18

        msg = event.channel.history( 100 ).take_while { |h| h.id != id.to_i }
        event.channel.delete_messages(msg)
        msg = "#{msg.length} mensagens retrocedidas de ##{event.channel.name}."

        Nyaa::Database::ModLog.create(
          event: :prune,
          description: msg,
          moderator: event.user.distinct,
          moderator_id: event_user.id,
          server_id: event.server.id
        )

        nil
      end

      command(:prune, help_available: false,
              permission_level: 2, permission_message: false) do |event, num|

        next "\\⚠ :: !prune [2-100] [usuário]" if event.message.mentions.empty? || ! num
        next "\\⚠ :: Não está entre o intervalo permitido." unless num.to_i >= 2 && num.to_i <= 100

        user = event.message.mentions.first.on(event.server)

        msg = []
        event.channel.history( num.to_i ).count do |h|
          msg.push h if h.author.id == user.id
        end

        event.channel.delete_messages(msg)

        msg = "#{msg.length} mensagens de #{user.distinct} removidas de ##{event.channel.name}."

        Nyaa::Database::ModLog.create(
          event: :prune,
          description: msg,
          moderator: event.user.distinct,
          moderator_id: event_user.id,
          server_id: event.server.id
        )

        nil
      end
    end
  end
end
