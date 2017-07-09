module Cygnus
  module Cygnus_Commands
    # ROLES
    # Manipula cargos de usuários.
    module Roles
      extend Discordrb::Commands::CommandContainer

      command :role, help_available: false, required_permissions: [:manage_roles], permission_message: false do |event, user, *args|
        next "\\⚠ :: !role [usuário] [cargo]" if event.message.mentions.empty? || args.empty?; role = args.join " "
        next "\\⚠ :: Cargo \"#{role}\" não existe!" unless role = event.server.roles.find { |r| r.name == role }

        user = event.message.mentions.first.on( event.server )

        if user.role? role
          user.remove_role role
          event << user.mention + " foi removido do cargo \"#{role.name}\"!"

          log = "Removeu o usuário #{user.distinct} do cargo #{role.name}."
          Cygnus::Database::Evento.create mod: event.user.distinct,
                                          mod_id: event.user.id,
                                          server_id: event.server.id,
                                          log: log

          return nil
        else
          user.add_role role
          event << user.mention + " foi adicionado ao cargo \"#{role.name}\"!"

          log = "Adicionou o usuário #{user.distinct} do cargo #{role.name}."
          Cygnus::Database::Evento.create mod: event.user.distinct,
                                          mod_id: event.user.id,
                                          server_id: event.server.id,
                                          log: log

          return nil
        end
      end
    end
  end
end
