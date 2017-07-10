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

      command :ticket, help_available: false, required_permissions: [:manage_messages], permission_message: false do |event, num, option = nil|
        next "\\⚠ :: !ticket #[id] [abrir/fechar]" if num.empty?

        # Foolproof, funciona mesmo sem o prefixo "#".
        t_number = num
        t_number = num[1..-1] if num.start_with? "#"

        ticket = Cygnus::Database::Report.where( id: t_number.to_i ).first
        next "Ticket não encontrado." if ticket.nil?
        next ticket.show if option.nil?

        ticket.update status: 0 if option.casecmp? "fechar"
        ticket.update status: 1 if option.casecmp? "abrir"
        ticket.save ? "Sucesso!" : "Ocorreu um erro."
      end

      # Em caso de flood.
      command :'ticket.del', help_available: false, required_permissions: [:manage_messages], permission_message: false do |event, user|
        next "\\⚠ :: !ticket.del [usuário]" if event.message.mentions.empty?

        Cygnus::Database::Report.where( id: event.message.mentions.first.id ).delete
        "Sucesso!"
      end

      command :tickets, help_available: false, required_permissions: [:manage_messages], permission_message: false do |event|
        ticket = Cygnus::Database::Report.where( status: 1 ).limit( 5 ).reverse_order :id

        msg = []
        msg << "**ÚLTIMOS 10 TICKETS EM ABERTO**"
        ticket.each do |t|
          msg << "**TICKET #{t.id}** - Por #{t.user} em #{t.created_on.strftime( "%d/%m/%Y %H:%M" )}."
        end

        msg.join( "\n" )
      end
    end
  end
end
