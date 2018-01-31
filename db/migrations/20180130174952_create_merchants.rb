Hanami::Model.migration do
  change do
    create_table :merchants do
      primary_key :id

      column :is_type, String, null: false, index: true, unique: true
      column :title, String, null: false
      column :metadata, 'jsonb', null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
