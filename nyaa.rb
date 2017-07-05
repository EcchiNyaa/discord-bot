require "discordrb"       # Discord API.
require "nokogiri"        # HTTP.
require "open-uri"        # HTTP.
require "sqlite3"         # Database.
require "yaml"            # Config Files.
require 'json'            # Parse json files.
require "open3"           # Shell.

# IMPORTANT!
DIR = File.dirname(__FILE__)
DB_DIR = "#{DIR}/database"
DATA_DIR = "#{DIR}/data"
CONFIG = YAML.load_file("#{DIR}/config/config.yml")

# REQUIRE ALL MODULES.
Dir["#{DIR}/modules/commands/*.rb"].each { |file| require file }
Dir["#{DIR}/modules/events/*.rb"].each { |file| require file }

bot = Discordrb::Commands::CommandBot.new token: CONFIG["token"], client_id: CONFIG["client_id"], prefix: CONFIG["prefix"]

# EVENT.
bot.include! Version
bot.include! User_Management

# COMMAND.
bot.include! Kill
bot.include! User_Info
bot.include! EcchiNyaa
bot.include! Set_Avatar
bot.include! Japanese
bot.include! Help

bot.run
