# bot.include! User_Info.
# Mostra uma tabela com informações do usuário.

module User_Info
  extend Discordrb::Commands::CommandContainer

    def self.user_info( event, u_user )
      event.channel.send_embed do |embed|
        embed.thumbnail = { url: u_user.avatar_url }
        embed.footer = { text: "Consultado em #{Time.now.strftime( "%d/%m/%Y" )} - #{event.server.name}." }
        embed.add_field name: "Nome", value: u_user.display_name, inline: true
        embed.add_field name: "Discriminante", value: u_user.distinct, inline: true
        embed.add_field name: "Membro desde", value: u_user.joined_at.strftime( "%d/%m/%Y" ), inline: true
        embed.add_field name: "Data de cadastro", value: u_user.creation_time.strftime( "%d/%m/%Y" ), inline: true
      end
    end

  command :info, description: "Mostra informações sobre um usuário." do |event|
    u_user = event.user
    u_user = event.message.mentions.first.on(event.server) unless event.message.mentions.empty?
    user_info event, u_user
  end
end
