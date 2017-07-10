module Cygnus
  module Cygnus_Commands
    # ERROR LOG.
    # Envia o log de erros ao administrador.
    module Log
      extend Discordrb::Commands::CommandContainer

      command :'query.eventos', help_available: false,
               permission_level: 2, permission_message: false do |event, option|

        if option.start_with? "#"
         num = option[1..-1]

         q = Cygnus::Database::Evento.where id: num
         next "Nenhum evento encontrado" unless q.count > 0

         q.first.show.join( "\n" )
        elsif option == "txt"
         event.channel.send_file File.open( Cygnus::Database::Evento.dump, "r" )
       elsif option == "total"
         "#{Cygnus::Database::Evento.max( :id )} logs administrativos encontrados!"
        else
         "Opção incorreta!"
        end
      end

      command :'query.afastamentos', help_available: false,
               permission_level: 2, permission_message: false do |event, option|

        if option.start_with? "#"
         num = option[1..-1]

         q = Cygnus::Database::Afastamento.where id: num
         next "Nenhum afastamento encontrado" unless q.count > 0

         q.first.show.join( "\n" )
        elsif option == "txt"
         event.channel.send_file File.open( Cygnus::Database::Afastamento.dump, "r" )
       elsif option == "total"
         "#{Cygnus::Database::Afastamento.max( :id )} punições encontradas!"
        else
         "Opção incorreta!"
        end
      end

      command :log, help_available: false,
               permission_level: 4, permission_message: false do |event|

        event.channel.send_file File.open( "#{DIR_LOG}/Nyaa.log", "r" )
      end

      command :'log.rm', help_available: false,
               permission_level: 4, permission_message: false do |event|

        File.open( "#{DIR_LOG}/Nyaa.log", "w" ) {}

        msg = "Deletou o log de erros."
        Cygnus::Database::Evento.create mod: event.user.distinct,
                                        mod_id: event.user.id,
                                        server_id: event.server.id,
                                        log: msg

        "Sucesso!"
      end
    end
  end
end
