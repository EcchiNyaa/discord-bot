module Cygnus
  module Database
    REPORTS = Sequel.connect("sqlite://#{DIR_DB}/reports.db")

    Sequel.extension :migration
    Sequel::Migrator.run REPORTS, "#{DIR_DB}/migrations/reports"

    class Report < Sequel::Model REPORTS[:reports]
      def after_save
        self.updated_on = Time.now
      end

      def show
        channel = BOT.server( server_id ).channels.find { |ch| ch.id == CONFIG["admin_channel_id"] }

        channel.send_embed do |embed|
          embed.title = "Ticket nº ##{id}"
          embed.color = "7EC0EE"
          embed.description = "Use \"!ticket ##{id} fechar\" para fechar o ticket."
          embed.add_field name: "Usuário", value: user, inline: true
          embed.add_field name: "Status", value: status == 1 ? "ABERTO" : "Fechado", inline: true if updated_on.nil?
          embed.add_field name: "Data da abertura", value: created_on.strftime( "%d/%m/%Y %H:%M" ), inline:true
          embed.add_field name: "Concluído em:", value: updated_on.strftime( "%d/%m/%Y %H:%M" ), inline: true unless updated_on.nil?
          embed.add_field name: "Conteúdo", value: content
        end
      end
    end
  end
end
