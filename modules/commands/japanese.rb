module Cygnus
  module Cygnus_Commands
    # bot.include! Japanese
    # Fornece definições, romanização e muito mais.
    module Japanese
      extend Discordrb::Commands::CommandContainer

      require "mojinizer"

      command :jp, description: "Dicionário Japonês > Inglês." do |event, word, def_number = 1|
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
          embed.add_field name: "Reading", value: "#{reading} (#{reading.romaji})", inline: true
          embed.add_field name: "English", value: english.join(", ")
        end
      end

      command :hiragana, description: "Conversor Romaji > Hiragana." do |event, *args|
        event << args.join( " " ).downcase.hiragana
      end

      command :katakana, description: "Conversor Romaji > Katakana." do |event, *args|
        event << args.join( " " ).downcase.katakana
      end

      command :romaji, description: "Conversor Japonês > Romaji." do |event, *args|
        romaji = Open3.capture3( "#{DATA_DIR}/sh/japanese.sh", args.join(" ") )
        event.channel.send_embed do |embed|
          embed.add_field name: "Original", value: args.join(" "), inline: true
          embed.add_field name: "Romaji (Estimativa)", value: romaji[0], inline: true
        end
      end

      command :jp_info, description: "Informações sobre a língua japonesa." do |event|
        event << "```"
        event << "http://jisho.org/"
        event << "http://www.guidetojapanese.org/learn/grammar"
        event << "http://maggiesensei.com/"
        event << "https://www.youtube.com/user/freejapaneselessons3"
        event << "https://ankiweb.net/shared/decks/japanese"
        event << "```"
      end
    end
  end
end
