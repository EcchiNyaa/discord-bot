module Cygnus
  module Cygnus_Commands
    # ADMINISTRAÇÃO
    # Módulo com funções relacionadas a administração.
    module Administration
      extend Discordrb::Commands::CommandContainer

      command :'bot.kill', help_available: false do |event|
        break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

        event.user.pm "Desligando..."

        msg = "Desligou o bot."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: msg

        exit # Desliga o bot.
      end

      command :'bot.avatar', help_available: false, required_permissions: [:administrator], permission_message: false do |event, img|
        next "\\⚠ :: !bot.avatar [url]" unless img

        event.bot.profile.avatar = open( img )
        event.user.pm "Sucesso."

        msg = "Alterou o avatar do bot para #{img}."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: msg

        return nil
      end

      command :kick, help_available: false, required_permissions: [:kick_members], permission_message: false do |event, user, *reason|
        next "\\⚠ :: !kick [usuário] [razão]" if event.message.mentions.empty? || reason.empty?

        event.server.kick( event.message.mentions.first.on( event.server ) )

        log = Cygnus::Database::Afastamento.create user: event.message.mentions.first.on( event.server ).distinct,
                                                   user_id: event.message.mentions.first.on( event.server ).id,
                                                   mod: event.user.distinct,
                                                   mod_id: event.user.id,
                                                   server_id: event.server.id,
                                                   reason: reason.join( " " ),
                                                   status: "Expulso"

        log.transparency if CONFIG["transparency"]
      end

      command :ban, help_available: false, required_permissions: [:kick_members], permission_message: false do |event, user, *reason|
        next "\\⚠ :: !ban [usuário] [razão]" if event.message.mentions.empty? || reason.empty?

        event.server.kick( event.message.mentions.first.on( event.server ) )

        log = Cygnus::Database::Afastamento.create user: event.message.mentions.first.on( event.server ).distinct,
                                                   user_id: event.message.mentions.first.on( event.server ).id,
                                                   mod: event.user.distinct,
                                                   mod_id: event.user.id,
                                                   server_id: event.server.id,
                                                   reason: reason.join( " " ),
                                                   status: "Banido"

        log.transparency if CONFIG["transparency"]
      end
    end
  end
end
