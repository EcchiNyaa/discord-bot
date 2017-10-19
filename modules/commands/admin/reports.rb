module Nyaa
  module Commands
    module Tickets
      extend Discordrb::Commands::CommandContainer

      command(:reportar,
              description: "Administração; Reportar problemas ou sugestões.") do |event, *args|

        next "\\⚠ :: !reportar [info]" if args.empty?

        ticket = Nyaa::Database::Ticket.create(
          user: event.user.distinct,
          user_id: event.user.id,
          server_id: event.server.id,
          content: args.join(" ")
        )

        ticket.show
      end

      command(:ticket, help_available: false,
              permission_level: 1, permission_message: false) do |event, num, option = nil|

        next "\\⚠ :: !ticket #[id] [fechar]" unless num

        # Foolproof, funciona mesmo sem o prefixo "#".
        t_number = num
        t_number = num[1..-1] if num.start_with? "#"

        ticket = Nyaa::Database::Ticket.find(id: t_number.to_i)
        next "Ticket não encontrado." if ticket.nil?
        next ticket.show if option.nil?

        option == fechar ? ( ticket.fechar; "Sucesso!" ) : "Opção incorreta"
      end

      command(:'ticket.del', help_available: false,
              permission_level: 1, permission_message: false) do |event, user|

        next "\\⚠ :: !ticket.del [usuário]" if event.message.mentions.empty?

        Nyaa::Database::Ticket.where(user_id: event.message.mentions.first.id).delete

        "Sucesso!"
      end

      command(:tickets, help_available: false,
              permission_level: 1, permission_message: false) do |event|

        ticket = Nyaa::Database::Ticket.where(status: 1).limit(10).reverse_order(:id)

        event << "```"
        ticket.each do |t|
          event << "**TICKET ##{t.id}** - Por #{t.user} em #{t.created_at.strftime("%d/%m/%Y %H:%M")}."
        end
        event << "```"
      end
    end
  end
end
