require "json"            # JSON.
require "open-uri"        # HTTP scraping.
require "sequel"          # SQLITE.
require "sqlite3"         # SQLITE.

module Cygnus
  module Cygnus_Commands
    # ECCHI NYAA
    # Armazena informações dos animes disponíveis no EcchiNyaa e fornece uma função de busca básica.
    module EcchiNyaa
      extend Discordrb::Commands::CommandContainer

      DB = Sequel.connect("sqlite://#{DIR_DB}/nyaa.db")

      Sequel.extension :migration
      Sequel::Migrator.run DB, "#{DIR_DB}/migrations/ecchinyaa"

      class Database
        def initialize
          @animes = DB[:animes]
          @ecchis = DB[:ecchis]
          @eroges = DB[:eroges]
        end

        def update
          tables = [
            { page: "animes", variable: "@animes" },
            { page: "ecchis", variable: "@ecchis" },
          # { page: "eroges", variable: "@eroges" }
          ]

          tables.each do |table|
            target = table[:page]
            api = JSON.parse( open( "http://localhost/wordpress/api-#{target}.json" ).read )

            t = eval table[:variable]

            api[target].each do |i|
              t.insert :nome => i["nome"],
                       :link => i["permalink"],
                       :cover => i["cover"],
                       :fansub => i["fansub"],
                       :sinopse => i["sinopse"]

              if target == "ecchis"
                i["ecchi_power"] = "-" if i["ecchi_power"] == nil

                q = @ecchis.where :link => i["permalink"]
                q.update :ecchi_power => i["ecchi_power"]
              end
            end
          end
        end

        def search( table, name )
          q = eval( table )
          q = q.where( Sequel.ilike( :nome, "%#{name}%" ) )
        end
      end

      command :anime, description: "[EcchiNyaa] Buscar por animes no catálogo do EcchiNyaa." do |event, *args|
        next "\\⚠ :: !anime [nome]" if args.empty?

        nyaa = Database.new
        res = nyaa.search "@animes", args.join( " " )

        if res.count == 1
          event.channel.send_embed do |embed|
            embed.title = res.first[:nome]
            embed.description = res.first[:sinopse]
            embed.thumbnail = { url: res.first[:cover] }
            embed.add_field name: "Fansub", value: res.first[:fansub], inline: true
            embed.add_field name: "URL", value: res.first[:link], inline: true
          end
        else
          event << "```"
          res.each { |r| event << r[:link] }
          event << "```"
        end
      end

      command :ecchi, description: "[EcchiNyaa] Buscar por ecchis no catálogo do EcchiNyaa." do |event, *args|
        next "\\⚠ :: !ecchi [nome]" if args.empty?

        nyaa = Database.new
        res = nyaa.search "@ecchis", args.join( " " )

        if res.count == 1
          event.channel.send_embed do |embed|
            embed.title = res.first[:nome]
            embed.description = res.first[:sinopse]
            embed.thumbnail = { url: res.first[:cover] }
            embed.add_field name: "EcchiPower", value: res.first[:ecchi_power].gsub(/(.{1})/m, '\\\\\1'), inline: true
            embed.add_field name: "Fansub", value: res.first[:fansub], inline: true
            embed.add_field name: "URL", value: res.first[:link]
          end
        else
          event << "```"
          res.each { |r| event << r[:link] }
          event << "```"
        end
      end
    end
  end
end
