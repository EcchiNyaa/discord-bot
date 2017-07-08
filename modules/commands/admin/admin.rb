module Cygnus
  module Cygnus_Commands
    # ADMINISTRAÇÃO
    # Módulo com funções relacionadas a administração.
    module Administration
      extend Discordrb::Commands::CommandContainer

      command :reportar, description: "[Administração] Reportar problemas ou sugestões." do |event, *args|
        ( event << "\\⚠ :: !reportar [info]"; break ) if args.empty?

        event.bot.channel( CONFIG["report_command_channel_id"] ).send_embed do |embed|
          embed.add_field name: "Nome", value: event.user.mention, inline: true
          embed.add_field name: "Discriminante", value: event.user.distinct, inline: true
          embed.add_field name: "Informação", value: args.join( " " )
        end
      end

      command :kill, help_available: false do |event|
        break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

        event.user.pm "Desligando..."

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Nyaa.log"
        log.info "⚑ Bot encerrado.", event.user.distinct, "ADMIN"

        exit # Desliga o bot.
      end

      command :bot_avatar, help_available: false do |event, img|
        break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

        ( event << "⚠ Uso !bot_avatar [url]"; break ) unless img

        event.bot.profile.avatar = open( img )
        event.user.pm "Sucesso."

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Nyaa.log"
        log.info "⚑ Avatar alterado para '#{img}'.", event.user.distinct, "ADMIN"
      end

      command :kick, help_available: false, required_permissions: [:kick_members] do |event|
        ( event << "\\⚠ :: !kick [usuário]"; break ) if event.message.mentions.empty?

        user = event.message.mentions.first.on( event.server )
        event.server.kick( user )

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Admin.log"
        log.info "⚑ Usuário '#{user.distinct}' foi kickado.", event.user.distinct, "ADMIN"
      end

      command :ban, help_available: false, required_permissions: [:ban_members] do |event, user|
        ( event << "\\⚠ :: !ban [usuário]"; break ) if event.message.mentions.empty?

        user = event.message.mentions.first.on( event.server )
        event.server.ban( user )

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Admin.log"
        log.info "⚑ Usuário '#{user.distinct}' foi banido.", event.user.distinct, "ADMIN"
      end
    end
  end
end
