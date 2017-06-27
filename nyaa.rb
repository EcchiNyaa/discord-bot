require "nokogiri"
require "open-uri"
require "sqlite3"
require "discordrb"
require "yaml"

class Nyaa
  def update( target )
    db = SQLite3::Database.new "nyaa.db" unless File.exists? "#{Dir.pwd}/nyaa.db"
    content = Nokogiri::HTML( open( "http://ecchinyaa.org/#{target}", "User-Agent" => "EcchiNyaa Bot v1.0" ), nil, "UTF-8" )

    # <div class=".entry_content">
    # [...]
    # <td><a href="/aldnoah-zero">Aldnoah.Zero</a></td>
    # [...]
    # </div>
    links = content.css ".entry-content a"

    db = SQLite3::Database.open "nyaa.db"
    db.execute "CREATE TABLE IF NOT EXISTS #{target}( id INTEGER PRIMARY KEY, nome TEXT, link TEXT, UNIQUE( nome, link ) )"

    links.each do |link|
      db.execute "INSERT OR IGNORE INTO #{target}( nome, link ) VALUES( '#{link.text}', 'https://ecchinyaa.org#{link['href']}' )"
    end

    db.close if db
  end

  def update_db
    self.update "animes"
    self.update "ecchis"
    self.update "eroges"
  end

  def search( target, argument )
    db = SQLite3::Database.open "nyaa.db"
    query = "SELECT link FROM #{target} WHERE nome LIKE ?;"
    link = db.execute query, "%#{argument}%"
    db.close if db

    return link
  end
end

abort "Arquivo de configuração não encontrado." unless File.exists? "#{Dir.pwd}/config.yml"
config = YAML::load_file( "config.yml" )

nyaa = Nyaa.new

# DB Update
# nyaa.update_db

# EcchiNyaa Bot
# https://discordapp.com/developers/applications/me
bot = Discordrb::Commands::CommandBot.new \
token: config["bot"]["token"], client_id: config["bot"]["client_id"], prefix: config["bot"]["prefix"]

def search_layout( event, res )
  event.respond "```#{ res.join("\n") }```" if res.length > 1
  event.respond "#{ res.join("\n") }" if res.length == 1
  event.respond "Nenhum resultado." if res.length == 0
end

bot.command :anime do |event, *text|
  res = nyaa.search "animes", text.join( " " )
  search_layout event, res
end

bot.command :ecchi do |event, *text|
  res = nyaa.search "ecchis", text.join( " " )
  search_layout event, res
end

bot.command :eroge do |event, *text|
  res = nyaa.search "eroges", text.join( " " )
  search_layout event, res
end

bot.run
