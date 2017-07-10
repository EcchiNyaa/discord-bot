module Cygnus
  module Cygnus_Commands
    module Tickets
      extend Discordrb::Commands::CommandContainer

      command :reportar, description: "[Administração] Reportar problemas ou sugestões." do |event, *args|
        next "\\⚠ :: !reportar [info]" if args.empty?

        ticket = Cygnus::Database::Report.create user: event.user.distinct,
                                                 user_id: event.user.id,
                                                 server_id: event.server.id,
                                                 content: args.join( " " )

        ticket.show
      end

      command :ticket, help_available: false,
               permission_level: 1, permission_message: false do |event, num, option = nil|

        next "\\⚠ :: !ticket #[id] [fechar]" unless num

        # Foolproof, funciona mesmo sem o prefixo "#".
        t_number = num
        t_number = num[1..-1] if num.start_with? "#"

        ticket = Cygnus::Database::Report.where( id: t_number.to_i ).first
        next "Ticket não encontrado." if ticket.nil?
        next ticket.show if option.nil?

        option == fechar ? ( ticket.close; "Sucesso!" ) : "Opção incorreta"
      end

      # Em caso de flood.
      command :'ticket.del', help_available: false,
                permission_level: 1, permission_message: false do |event, user|

        next "\\⚠ :: !ticket.del [usuário]" if event.message.mentions.empty?

        Cygnus::Database::Report.where( user_id: event.message.mentions.first.id ).delete
        "Sucesso!"
      end

      command :'ticket.autolimpeza', help_available: false,
               permission_level: 1, permission_message: false do |event|

        Cygnus::Database::Report.autolimpeza.fechar
        "Sucesso!"
      end

      command :tickets, help_available: false,
               permission_level: 1, permission_message: false do |event|

        ticket = Cygnus::Database::Report.where( status: 1 ).limit( 5 ).reverse_order :id

        event << "```"
        ticket.each do |t|
          event << "**TICKET ##{t.id}** - Por #{t.user} em #{t.created_on.strftime( "%d/%m/%Y %H:%M" )}."
        end
        event << "```"
      end
    end
  end
end
