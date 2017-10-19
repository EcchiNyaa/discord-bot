Sequel.migration do
  up do
    create_table :stats do
      primary_key :id

      Integer :server_id, unique: true
      Integer :messages,  default: 0
      Integer :commands,  default: 0

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:stats)
  end
end
