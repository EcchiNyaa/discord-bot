module Nyaa
  module Database
    class Ticket < Sequel::Model
      def show
        channel = BOT.server( server_id ).channels.find { |ch| ch.id == CONFIG["admin_channel_id"] }

        channel.send_embed do |embed|
          embed.title = "Ticket nº ##{id}"
          embed.color = "7EC0EE"
          embed.description = "Use \"!ticket ##{id} fechar\" para fechar o ticket."
          embed.add_field name: "Usuário", value: user, inline: true
          embed.add_field name: "Status", value: "ABERTO" if status == 1
          embed.add_field name: "Data da abertura", value: created_at.strftime( "%d/%m/%Y %H:%M" ), inline:true
          embed.add_field name: "Data de conclusão", value: updated_at.strftime( "%d/%m/%Y %H:%M" ), inline: true unless updated_at.nil?
          embed.add_field name: "Conteúdo", value: content
        end
      end

      def fechar
        self.update(status: 0)
      end
    end
  end
end
