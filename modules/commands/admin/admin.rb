module Nyaa
  module Commands
    module Admin
      extend Discordrb::Commands::CommandContainer

      command(:'bot.kill', help_available: false,
              permission_level: 4, permission_message: false) do |event|

        event.user.pm "Desligando..."

        Nyaa::Database::ModLog.create(
          event: :shutdown,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id
        )

        exit
      end

      command(:'bot.reiniciar', help_available: false,
              permission_level: 4, permission_message: false) do |event|

        event.user.pm "Reiniciando..."

        Nyaa::Database::ModLog.create(
          event: :restart,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id
        )

        exec "#{DIR}/start"
      end

      command(:'bot.avatar', help_available: false,
              permission_level: 4, permission_message: false) do |event, img|

        next "\\⚠ :: !bot.avatar [url]" unless img

        event.bot.profile.avatar = open(img)

        Nyaa::Database::ModLog.create(
          event: :avatar,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id
        )

        "Avatar alterado!"
      end

      command(:kick, help_available: false,
              permission_level: 2, permission_message: false) do |event, user, *reason|

        next "\\⚠ :: !kick [usuário] [razão]" if event.message.mentions.empty? || reason.empty?

        # event.server.kick( event.message.mentions.first.on( event.server ) )
        user = event.message.mentions.first.on(event.server)

        log = Nyaa::Database::Ban.create(
          event: :kick,
          user: user.distinct,
          user_id: user.id,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id,
          reason: reason.join(" ")
        )

        log.transparency if CONFIG["transparency"]
      end

      command(:ban, help_available: false,
              permission_level: 3, permission_message: false) do |event, user, *reason|

        next "\\⚠ :: !ban [usuário] [razão]" if event.message.mentions.empty? || reason.empty?

        # event.server.kick( event.message.mentions.first.on( event.server ) )
        user = event.message.mentions.first.on(event.server)

        log = Nyaa::Database::Ban.create(
          event: :ban,
          user: user.distinct,
          user_id: user.id,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id,
          reason: reason.join(" ")
        )

        log.transparency if CONFIG["transparency"]
      end
    end
  end
end
