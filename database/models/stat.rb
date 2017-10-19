module Nyaa
  module Database
    class Stat < Sequel::Model
      def show
        msg = []
        msg << "**Mensagens analisadas:** #{messages}."
        msg << "**Comandos efetuados:** #{commands}."
        msg << "**Último evento:** #{updated_at.strftime("%d/%m/%Y %H:%M")}."

        msg.join("\n")
      end
    end
  end
end
