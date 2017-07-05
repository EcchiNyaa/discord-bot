module Cygnus
  module Cygnus_Commands
    # bot.include! Administration
    # Módulo de administração.
    module Administration
      extend Discordrb::Commands::CommandContainer
      
      command :reportar, description: "Reportar problemas a administração." do |event, *args|
        event.bot.channel( CONFIG["admin_channel_id"] ).send_embed do |embed|
          embed.add_field name: "Nome", value: event.user.mention, inline: true
          embed.add_field name: "Discriminante", value: event.user.distinct, inline: true
          embed.add_field name: "Informação", value: args.join( " " )
        end
      end

      command :kill, help_available: false do |event|
        break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

        event.user.pm "Desligando..."
        exit
      end

      command :bot_avatar, help_available: false do |event, img|
        break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

        event.bot.profile.avatar = open( img )
        event.user.pm "Sucesso."
      end
    end
  end
end
