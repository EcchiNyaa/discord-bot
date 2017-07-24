Sequel.migration do
  up do
    create_table :reports do
      primary_key :id

      String :user, null: false
      Integer :user_id, null: false
      Integer :server_id, null: false
      Integer :status, default: 1 # 1 = Aberto, 0 = Fechado
      String :content, null: false

      DateTime :created_on, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_on
    end
  end

  down do
    drop_table(:reports)
  end
end
