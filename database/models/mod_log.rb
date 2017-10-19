module Nyaa
  module Database
    class ModLog < Sequel::Model
      plugin :enum
      enum   :event, [:eval, :shutdown, :restart]

      def template(msg)
        msg << "**Evento ##{id}**."
        msg << "**Moderador:** #{moderator}"
        msg << "**Data:** #{created_at.strftime("%d/%m/%Y %H:%M")}"
        msg << "**Evento:** #{event}\n"
      end

      def show
        msg = []
        template msg
      end
    end
  end
end
