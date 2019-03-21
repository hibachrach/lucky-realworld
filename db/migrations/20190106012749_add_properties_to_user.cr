class AddPropertiesToUser::V20190106012749 < Avram::Migrator::Migration::V1
  def migrate
    alter :users do
      add username : String, fill_existing_with: "Irrelevant as there are no users"
      add bio : String?
      add image : String?
    end
  end

  def rollback
    alter :users do
      remove :username
      remove :bio
      remove :image
    end
  end
end
