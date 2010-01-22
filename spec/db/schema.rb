ActiveRecord::Schema.define(:version => 1) do
  create_table :with_createds, :force => true do |t|
    t.column :something, :string
    t.column :created_by_id, :integer
    t.column :updated_by_id, :integer
  end
  create_table :without_createds, :force => true do |t|
    t.column :something, :string
  end
	create_table :users, :force => true do |t|
    t.column :something, :string
  end
end