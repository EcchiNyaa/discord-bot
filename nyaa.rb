require "yaml"
require "discordrb"
require "nokogiri"
require "open-uri"
require "sqlite3"

class Database
  def initialize
    @db_dir = "#{File.dirname(__FILE__)}/db"
    @database = "#{@db_dir}/nyaa.db"

    self.db_init
  end

  def db_init
    Dir.mkdir @db_dir unless File.exists? @db_dir
    SQLite3::Database.new @database unless File.exists? @database
  end

  def update( target )
    content = Nokogiri::HTML( open( "http://ecchinyaa.org/#{target}", "User-Agent" => "EcchiNyaa Bot" ) )
    links = content.css ".entry-content a"

    begin
      db = SQLite3::Database.open @database
      db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS #{target}(
        id INTEGER PRIMARY KEY,
        nome TEXT,
        link TEXT,
        UNIQUE( nome, link )
      );
      SQL

      links.each do |link|
        insert = db.prepare "INSERT OR IGNORE INTO #{target}( nome, link ) VALUES( ?, ?)"
        insert.bind_params link.text, "https://ecchinyaa.org#{link['href']}"
        insert.execute
      end
    rescue SQLite3::Exception => error
      puts "Ocorreu um erro: #{error}"
    end
  end

  def update_db
    self.update "animes"
    self.update "ecchis"
    self.update "eroges"
  end

  def search( target, argument )
    begin
      db = SQLite3::Database.open @database

      search = db.prepare "SELECT link FROM #{target} WHERE nome LIKE ?"
      search.bind_params "%#{argument}%"
      result = search.execute
    rescue SQLite3::Exception => error
      puts "Ocorreu um erro: #{error}"
    end

    # Return array (to_a).
    return result.to_a
  end
end

CONFIG = "#{File.dirname(__FILE__)}/config/config.yml"

abort "Arquivo de configuração não encontrado." unless File.exists? CONFIG
config = YAML::load_file( CONFIG )

# Init DB.
# /db/nyaa.db
nyaa = Database.new

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

bot.command :info do |event|
  event.respond "<https://github.com/EcchiNyaa/discord-bot>"
  event.respond "Commit: #{`cd #{File.dirname(__FILE__)} && git log -1 --format="%H (%ar)"`.strip}."
end

# ADMIN
bot.command :db do |event|
  id = config["bot"]["super_admin"].split( " " )
  break unless id.include? event.user.id.to_s
  nyaa.update_db
  event.respond "Sucesso!"
end

bot.run
