Sequel.migration do
  up do
    create_table :animes do
      primary_key :id

      String :nome
      String :link, unique: true
      String :cover
      String :sinopse
      String :fansub

      DateTime :timestamp, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table :ecchis do
      primary_key :id

      String :nome
      String :link, unique: true
      String :cover
      String :sinopse
      String :fansub
      String :ecchi_power

      DateTime :timestamp, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table :eroges do
      primary_key :id

      String :nome
      String :link, unique: true
      String :cover
      String :idioma

      DateTime :timestamp, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:users)
    drop_table(:ecchis)
    drop_table(:eroges)
  end
end
