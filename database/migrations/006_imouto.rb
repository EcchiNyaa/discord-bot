Sequel.migration do
  up do
    create_table :imoutos do
      primary_key :id

      Integer :user_id, null: false, unique: true
      Integer :imoutos, default: 0

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:imoutos)
  end
end
