module Cygnus
  module Cygnus_Events
    # developer -> Pode manipular logs para debug, reiniciar e desligar o bot.
    # admin -> Pode banir usuários.
    # moderator -> Pode kickar usuários.
    # colaborator -> Pode manipular tickets.
    module Permissions
      extend Discordrb::EventContainer

      ready do |event|
        server_roles = [
          { server_id: CONFIG["server_id"], role: CONFIG["developer"], permission: 4 },
          { server_id: CONFIG["server_id"], role: CONFIG["admin"], permission: 3 },
          { server_id: CONFIG["server_id"], role: CONFIG["moderator"], permission: 2 },
          { server_id: CONFIG["server_id"], role: CONFIG["colaborator"], permission: 1 }
        ]

        server_roles.each do |hash|
          next unless role = event.bot.server( CONFIG["server_id"] ).roles.find { |r| r.name == hash[:role] }

          BOT.set_role_permission role.id, hash[:permission]
        end
      end
    end
  end
end
