module Nyaa
  module Events
    module Stats
      extend Discordrb::EventContainer

      message do |event|
        db = Nyaa::Database::Stat

        server = db.find(server_id: event.server.id)
        server = db.create(server_id: event.server.id) if server.nil?

        server.messages += 1
        server.commands += 1 if event.message.content.start_with?(CONFIG["prefix"])

        server.save
      end
    end
  end
end
