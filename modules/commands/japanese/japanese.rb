require "mojinizer"
require "json"
require "open3"

module Cygnus
  module Cygnus_Commands
    # LÍNGUA JAPONESA
    # Fornece definições e romanização, só é compatível com Linux.
    module Japanese
      extend Discordrb::Commands::CommandContainer

      command :jp, description: "[Japonês] Dicionário Japonês > Inglês." do |event, word, def_number = 1|
        next "\\⚠ :: !jp [palavra] [opcional: número inteiro]" unless word

        jp = JSON.parse( open( "http://jisho.org/api/v1/search/words?keyword=#{word}" ).read )

        def_number = 1 if def_number.to_i == 0
        def_number = def_number.to_i - 1

        # !jp kami   -> mostra a 1ª definição [0].
        # !jp kami 2 -> mostra a 2ª definição [1].
        kanji   = jp["data"][def_number]["japanese"][0]["word"]
        reading = jp["data"][def_number]["japanese"][0]["reading"]
        english = jp["data"][def_number]["senses"][0]["english_definitions"]

        event.channel.send_embed do |embed|
          embed.add_field name: "Kanji", value: kanji, inline: true
          embed.add_field name: "Leitura", value: "#{reading} (#{reading.romaji})", inline: true
          embed.add_field name: "Significado", value: english.join(", ")
        end
      end

      command :hiragana, description: "[Japonês] Conversor Romaji > Hiragana." do |event, *words|
        next "\\⚠ :: !hiragana [palavra]" if words.empty?

        event << words.join( " " ).downcase.hiragana
      end

      command :katakana, description: "[Japonês] Conversor Romaji > Katakana." do |event, *words|
        next "\\⚠ :: !katakana [palavra]" if words.empty?

        event << words.join( " " ).downcase.katakana
      end

      command :romaji, description: "[Japonês] Conversor Japonês > Romaji." do |event, *kanji|
        next "\\⚠ :: !romaji [frase]" if kanji.empty?

        romaji = Open3.capture3( "#{DIR_DATA}/sh/japanese.sh", kanji.join( " " ) )
        event.channel.send_embed do |embed|
          embed.add_field name: "Original", value: kanji.join( " " ), inline: true
          embed.add_field name: "Romaji ( Estimativa )", value: romaji[0], inline: true
        end
      end

      command :jp_info, description: "[Japonês] Informações sobre a língua japonesa." do |event|
        event << "http://jisho.org/"
        event << "http://www.guidetojapanese.org/learn/grammar"
        event << "http://maggiesensei.com/"
        event << "https://www.youtube.com/user/freejapaneselessons3"
        event << "https://ankiweb.net/shared/decks/japanese"
      end
    end
  end
end
