module Nyaa
  module Events
    module Stalker
      extend Discordrb::EventContainer

      private_message do |event|
        Nyaa::Database::Pm.create(
          user: event.message.author.distinct,
          user_id: event.message.author.id,
          message: event.message.content
        )
      end
    end
  end
end
