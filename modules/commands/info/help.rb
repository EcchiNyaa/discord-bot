module Cygnus
  module Cygnus_Commands
    # HELP
    # Sobrescreve o comando !help padrão, por um mais organizado e em português.
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
        max_command_size = help_command.max_by( &:length ).length

        last = ""

        event << "```"
        help.each do |cmd, description|
          whitespace = max_command_size - cmd.length
          whitespace = " " * whitespace.to_i

          # COMANDOS SEMELHANTES SÃO AGRUPADOS.
          # Por exemplo, entre '[Japonês] !hiragana' e '[Japonês] !katakana' não há quebra de linha.
          fw = description.split.first
          last == fw ? if_linebreak = nil : if_linebreak = "\n" unless fw == help_description.first
          last = description.split.first

          event << "#{if_linebreak}!#{cmd}#{whitespace} -> #{description}"
        end
        event << "```"
      end
    end
  end
end
