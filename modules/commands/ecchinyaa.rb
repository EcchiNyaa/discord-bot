# bot.include! EcchiNyaa
# Armazena em uma tabela os animes do EcchiNyaa, e fornece uma função de busca básica.

module EcchiNyaa
  extend Discordrb::Commands::CommandContainer

  DB_DIR = "#{DIR}/database"
  DATABASE = "#{DB_DIR}/nyaa.db"

  class Database
    def initialize
      Dir.mkdir DB_DIR unless File.exists? DB_DIR
      SQLite3::Database.new DATABASE unless File.exists? DATABASE
    end

    def update( target )
      content = Nokogiri::HTML( open( "http://ecchinyaa.org/#{target}", "User-Agent" => "EcchiNyaa Bot" ) )
      links = content.css ".entry-content a"

      begin
        db = SQLite3::Database.open DATABASE
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
        db = SQLite3::Database.open DATABASE

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

  nyaa = Database.new

  def self.search_layout( event, res )
    event.respond "```#{ res.join("\n") }```" if res.length > 1
    event.respond "#{ res.join("\n") }" if res.length == 1
    event.respond "Nenhum resultado." if res.length == 0
  end

  command :anime, description: "Busca por animes no catálogo do EcchiNyaa." do |event, *text|
    res = nyaa.search "animes", text.join( " " )
    search_layout event, res
  end

  command :ecchi, description: "Busca por ecchis no catálogo do EcchiNyaa." do |event, *text|
    res = nyaa.search "ecchis", text.join( " " )
    search_layout event, res
  end

  command :eroge, description: "Busca por eroges no catálogo do EcchiNyaa." do |event, *text|
    res = nyaa.search "eroges", text.join( " " )
    search_layout event, res
  end

  command :db, help_available: false do |event|
    break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

    nyaa.update_db
    event.respond "Database atualizada com sucesso."
  end
end
