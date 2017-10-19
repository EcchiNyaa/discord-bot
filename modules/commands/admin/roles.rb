module Nyaa
  module Commands
    module Roles
      extend Discordrb::Commands::CommandContainer

      command(:role, help_available: false,
              permission_level: 4, permission_message: false) do |event, user, *args|

        next "\\⚠ :: !role [usuário] [cargo]" if event.message.mentions.empty? || args.empty?
        next "\\⚠ :: Cargo \"#{args.join}\" não existe!" unless role = event.server.roles.find { |r| r.name == args.join }

        user = event.message.mentions.first.on(event.server)

        if user.role? role
          user.remove_role(role)
          event << "#{user.mention} foi removido do cargo \"#{role.name}\"!"

          msg = "Usuário #{user.distinct} removido do cargo #{role.name}."

          Nyaa::Database::ModLog.create(
            event: :role,
            description: msg,
            moderator: event.user.distinct,
            moderator_id: event.user.id,
            server_id: event.server.id
          )

          nil
        else
          user.add_role(role)
          event << "#{user.mention} foi adicionado ao cargo \"#{role.name}\"!"

          msg = "Usuário #{user.distinct} removido do cargo #{role.name}."

          Nyaa::Database::ModLog.create(
            event: :role,
            description: msg,
            moderator: event.user.distinct,
            moderator_id: event.user.id,
            server_id: event.server.id
          )

          nil
        end
      end
    end
  end
end
