Sequel.migration do
  up do
    create_table :afastamentos do
      primary_key :id

      String :status, null: false # "Banido", "Expulso", "Banimento Removido"
      String :user, null: false
      Integer :user_id, null: false
      String :mod, null: false
      Integer :mod_id, null: false
      Integer :server_id, null: false
      String :reason

      DateTime :created_on, default: Sequel::CURRENT_TIMESTAMP
    end

    create_table :eventos do
      primary_key :id

      String :mod, null: false
      Integer :mod_id, null: false
      String :log, null: false
      Integer :server_id, null: false

      DateTime :created_on, default: Sequel::CURRENT_TIMESTAMP
    end
  end
  down do
    drop_table(:status)
    drop_table(:eventos)
  end
end
