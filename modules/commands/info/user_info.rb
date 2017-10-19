module Nyaa
  module Commands
    module UserInfo
      extend Discordrb::Commands::CommandContainer

      def self.user_info(event, user)
        event.channel.send_embed do |e|
          e.thumbnail = { url: user.avatar_url }
          e.footer    = { text: "Consultado em #{Time.now.strftime( "%d/%m/%Y" )} - #{event.server.name}." }
          e.add_field name: "Nome", value: user.display_name, inline: true
          e.add_field name: "Discriminante", value: user.distinct, inline: true
          e.add_field name: "Membro desde", value: user.joined_at.strftime("%d/%m/%Y"), inline: true
          e.add_field name: "Data de cadastro", value: user.creation_time.strftime("%d/%m/%Y"), inline: true
        end
      end

      command :info, description: "Info; Mostra informações sobre um usuário." do |event|
        user = event.user
        user = event.message.mentions.first.on(event.server) unless event.message.mentions.empty?
        user_info event, user
      end
    end
  end
end
