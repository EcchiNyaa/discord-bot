Sequel.migration do
  up do
    create_table :animes do
      primary_key :id

      String :title
      String :cover
      String :url, unique: true
      String :synopsis
      String :fansub

      Integer :type # enum anime/ecchi
      Integer :ecchi_power

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:animes)
  end
end
