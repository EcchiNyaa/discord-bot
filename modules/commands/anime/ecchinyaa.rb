module Cygnus
  module Cygnus_Commands
    # ECCHI NYAA
    # Armazena informações dos animes disponíveis no EcchiNyaa e fornece uma função de busca básica.
    module EcchiNyaa
      extend Discordrb::Commands::CommandContainer

      command :anime, description: "[EcchiNyaa] Buscar por animes no catálogo do EcchiNyaa." do |event, *args|
        next "\\⚠ :: !anime [nome]" if args.empty?

        anime = Cygnus::Database::Anime.where( Sequel.ilike( :nome, "%#{args.join( " " )}%" ) )
        next "Nada encontrado." if anime.count == 0

        if anime.count == 1
          event.channel.send_embed do |embed|
            embed.title = anime.first[:nome]
            embed.description = anime.first[:sinopse]
            embed.thumbnail = { url: anime.first[:cover] }
            embed.add_field name: "Fansub", value: anime.first[:fansub], inline: true
            embed.add_field name: "URL", value: anime.first[:link], inline: true
          end
        else
          event << "```"
          anime.each { |r| event << r[:link] }
          event << "```"
        end
      end

      command :ecchi, description: "[EcchiNyaa] Buscar por ecchis no catálogo do EcchiNyaa." do |event, *args|
        next "\\⚠ :: !ecchi [nome]" if args.empty?

        ecchi = Cygnus::Database::Ecchi.where( Sequel.ilike( :nome, "%#{args.join( " " )}%" ) )
        next "Nada encontrado." if ecchi.count == 0

        if ecchi.count == 1
          event.channel.send_embed do |embed|
            embed.title = ecchi.first[:nome]
            embed.description = ecchi.first[:sinopse]
            embed.thumbnail = { url: ecchi.first[:cover] }
            embed.add_field name: "EcchiPower", value: ecchi.first[:ecchi_power].gsub(/(.{1})/m, '\\\\\1'), inline: true
            embed.add_field name: "Fansub", value: ecchi.first[:fansub], inline: true
            embed.add_field name: "URL", value: ecchi.first[:link], inline: true
          end
        else
          event << "```"
          ecchi.each { |r| event << r[:link] }
          event << "```"
        end
      end

      command :"anime.atualizar", help_available: false,
               permission_level: 4 do |event|

        Cygnus::Database::Anime.update!
        "Sucesso!"
      end

      command :"ecchi.atualizar", help_available: false,
               permission_level: 4 do |event|

        Cygnus::Database::Ecchi.update!
        "Sucesso!"
      end
    end
  end
end
