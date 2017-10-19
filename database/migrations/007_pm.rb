Sequel.migration do
  up do
    create_table(:pms) do
      primary_key :id

      String  :message
      String  :user
      Integer :user_id

      DateTime :created_at
      Datetime :updated_at
    end
  end

  down do
    drop_table(:pms)
  end
end
