module Nyaa
  module Commands
    module EcchiNyaa
      extend Discordrb::Commands::CommandContainer

      command(:anime, description: "EcchiNyaa; Busca por animes no catálogo do EcchiNyaa.") do |event, *args|
        next "\\⚠ :: !anime [nome]" if args.empty?

        anime = Nyaa::Database::Anime.where(Sequel.ilike(:title, "%#{args.join(" ")}%"))
        next "Nada encontrado." if anime.count.zero?

        if anime.count == 1
          event.channel.send_embed do |embed|
            embed.title = anime.first[:title]
            embed.description = anime.first[:sinopsis]
            embed.thumbnail = { url: anime.first[:cover] }
            embed.add_field name: "EcchiPower", value: anime.first[:ecchi_power].gsub(/(.{1})/m, '\\\\\1'), inline: true if anime.type == :ecchi
            embed.add_field name: "Fansub", value: anime.first[:fansub], inline: true
            embed.add_field name: "URL", value: anime.first[:url], inline: true
          end
        else
          event << "```"
          anime.each { |r| event << r[:link] }
          event << "```"
        end
      end

      command(:"anime.atualizar", help_available: false,
              permission_level: 4, permission_message: false) do |event|

        Nyaa::Database::Anime.update!

        "Sucesso!"
      end
    end
  end
end
