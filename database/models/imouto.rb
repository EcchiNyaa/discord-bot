module Cygnus
  module Database
    class Imouto < Sequel::Model
      def validate
        seconds_passed = Time.now - updated_on
        interval = 4 * 3600
        return errors.add :created_on, "Intervalo mínimo de 4 horas!" unless seconds_passed > interval

        self.updated_on = Time.now
      end
    end
  end
end
