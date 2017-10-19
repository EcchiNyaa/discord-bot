module Nyaa
  module Commands
    module Eval
      extend Discordrb::Commands::CommandContainer

      command(:eval, help_available: false,
              permission_level: 4, permission_message: false) do |event, *command|

        next "\\⚠ :: !eval [código]" if command.empty?

        Nyaa::Database::ModLog.create(
          event: :eval,
          moderator: event.user.distinct,
          moderator_id: event.user.id,
          server_id: event.server.id,
        )

        begin
          eval(command.join(" "))
        rescue => error
          "```#{error}```"
        end
      end
    end
  end
end
