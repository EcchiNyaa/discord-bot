module Cygnus
  module Cygnus_Commands
    # EVAL.
    # Envia um comando diretamente ao bot.
    module Eval
      extend Discordrb::Commands::CommandContainer

      command :eval, help_available: false,
               permission_level: 4, permission_message: false do |event, *command|

        next "\\⚠ :: !eval [código]" if command.empty?

        log = "Utilizou o comando !eval: #{command.join( " " )}."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: log

        begin
          eval( command.join( " " ) )
        rescue => error
          "```#{error}```"
        end
      end
    end
  end
end
