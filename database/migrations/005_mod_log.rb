Sequel.migration do
  up do
    create_table(:mod_logs) do
      primary_key :id

      String  :moderator
      Integer :moderator_id
      Integer :server_id

      Integer :event
      String  :description

      DateTime :created_at
      Datetime :updated_at
    end
  end

  down do
    drop_table(:mod_logs)
  end
end
