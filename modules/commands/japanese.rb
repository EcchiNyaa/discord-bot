# bot.include! Japanese
# Japanese dictionary.

module Japanese
  extend Discordrb::Commands::CommandContainer

  require "mojinizer"

  command :jp, description: "Dicionário Japonês -> Inglês." do |event, arg|
    jp = JSON.parse( open( "http://jisho.org/api/v1/search/words?keyword=#{arg}" ).read )

    # First result only.
    kanji   = jp["data"][0]["japanese"][0]["word"]
    reading = jp["data"][0]["japanese"][0]["reading"]
    english = jp["data"][0]["senses"][0]["english_definitions"]

    event.channel.send_embed do |embed|
      embed.add_field name: "Kanji", value: kanji, inline: true
      embed.add_field name: "Reading", value: "#{reading} (#{reading.romaji})", inline: true
      embed.add_field name: "English", value: english.join(", ")
    end
  end

  command :hiragana, description: "Conversor Romaji -> Hiragana." do |event, *args|
    event << args.join( " " ).downcase.hiragana
  end

  command :katakana, description: "Conversor Romaji -> Katakana." do |event, *args|
    event << args.join( " " ).downcase.katakana
  end

  command :romaji, description: "Conversor Japonês -> Romaji." do |event, *args|
    romaji = Open3.capture3( "#{DATA_DIR}/sh/japanese.sh", args.join(" ") )
    event << "[~] " + romaji[0]
  end
end
