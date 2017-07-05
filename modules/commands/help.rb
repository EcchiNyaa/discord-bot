module Cygnus
  module Cygnus_Commands
    # bot.include! Help
    # Sobrescreve o comando !help padrão.
    module Help
      extend Discordrb::Commands::CommandContainer

      command :help, help_available: false do |event|
        help_command = Array.new
        help_description = Array.new

        event.bot.commands.each do |name, command|
          attributes = command.instance_variable_get( "@attributes" )

          next unless attributes[:help_available]
          help_command.push name
          help_description.push attributes[:description]
        end

        # Pega a quantidade de caracteres do maior comando,
        # será utilizado para alinhar e indentar a caixa de comandos.
        help = help_command.zip help_description
        max_command_size = help_command.max_by(&:length).length

        event << "```"
        help.each do |cmd, description|
          whitespace = max_command_size - cmd.length
          whitespace = " " * whitespace.to_i
          event << "!#{cmd}#{whitespace} -> #{description}"
        end
        event << "```"
      end
    end
  end
end
