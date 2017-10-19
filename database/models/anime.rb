module Nyaa
  module Database
    class Anime < Sequel::Model
      dataset_module do
        def update!
          api = JSON.parse(open("http://localhost/wordpress/api-animes.json").read)

          api["animes"].each do |item|
            # item["ecchi_power"] ||= "-"
            self.insert nome: item["nome"],
                        link: item["permalink"],
                        cover: item["cover"],
                        fansub: item["fansub"],
                        sinopse: item["sinopse"]
          end
        end
      end
    end
  end
end
