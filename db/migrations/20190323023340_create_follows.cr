class CreateFollows::V20190323023340 < Avram::Migrator::Migration::V1
  def migrate
    create :follows do
      add_belongs_to follower : User, on_delete: :do_nothing

      # `add_belongs_to` always creates an index so we must create this column
      # with `add_column` instead
      add_column :followed_id,
        type: Avram::Migrator::PrimaryKeyType::Serial.db_type,
        optional: false,
        reference: "users"
    end
    # Can't create a multi-column index with `add_index` yet
    create_index table_name: :follows,
      columns: [:followed_id, :follower_id],
      unique: true
  end

  def rollback
    drop :follows
  end
end
