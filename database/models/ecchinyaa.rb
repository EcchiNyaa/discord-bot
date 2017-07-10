require "json"
require "open-uri"
require "sequel"
require "sqlite3"

module Cygnus
  module Database
    EN = Sequel.connect("sqlite://#{DIR_DB}/nyaa.db")

    Sequel.extension :migration
    Sequel::Migrator.run EN, "#{DIR_DB}/migrations/ecchinyaa"

    class Anime < Sequel::Model EN[:animes]
      dataset_module do
        def update!
          api = JSON.parse( open( "http://localhost/wordpress/api-animes.json" ).read )

          api["animes"].each do |item|
            self.insert nome: item["nome"],
                        link: item["permalink"],
                        cover: item["cover"],
                        fansub: item["fansub"],
                        sinopse: item["sinopse"]
          end
        end
      end
    end

    class Ecchi < Sequel::Model EN[:ecchis]
      dataset_module do
        def update!
          api = JSON.parse( open( "http://localhost/wordpress/api-ecchis.json" ).read )

          api["ecchis"].each do |item|
            item["ecchi_power"] ||= "-"

            self.insert nome: item["nome"],
                        link: item["permalink"],
                        cover: item["cover"],
                        fansub: item["fansub"],
                        sinopse: item["sinopse"],
                        ecchi_power: item["ecchi_power"]
          end
        end
      end
    end

    # REVERTIDO!
    # class Eroge < Sequel::Model LOG[:eroges]
    # end

  end
end
