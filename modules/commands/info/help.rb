module Nyaa
  module Commands
    module Help
      extend Discordrb::Commands::CommandContainer

      command :help, help_available: false do |event|
        help = []

        event.bot.commands.each do |name, command|
          attributes = command.instance_variable_get("@attributes")
          next unless attributes[:help_available]

          help << {
            name: "#{CONFIG["prefix"]}#{name}",

            category:    attributes[:description].split("; ").first,
            description: attributes[:description].split("; ").last
          }
        end

        indentation = help.max_by { |k| k[:name] }[:name].length
        help = help.sort_by { |k| k[:category] }

        last_category = nil

        msg = []
        help.each do |command|
          category = command[:category]
          last_category == category ? header = false : header = true
          last_category = category

          whitespace = " " * (indentation - command[:name].length)

          msg << "\n[#{command[:category]}]" if header
          msg << " #{command[:name]}#{whitespace} --> #{command[:description]}"
        end

        event.channel.send_embed do |embed|
          embed.title = "NYAA :: Comando de Ajuda."
          embed.description = "```#{msg.join("\n")}```"
          embed.color = "9370DB"
        end
      end
    end
  end
end
