Sequel.migration do
  up do
    create_table :stats do
      primary_key :id

      Integer :server_id, null: false, unique: true
      Integer :messages, default: 0
      Integer :commands, default: 0

      DateTime :created_on, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_on, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:stats)
  end
end
