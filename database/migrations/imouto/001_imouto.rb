Sequel.migration do
  up do
    create_table :users do
      primary_key :id

      Integer :user, null: false, unique: true
      Integer :imoutos, default: 0

      DateTime :created_on, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_on
    end
  end

  down do
    drop_table(:users)
  end
end
