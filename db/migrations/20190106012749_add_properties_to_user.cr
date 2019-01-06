class AddPropertiesToUser::V20190106012749 < LuckyRecord::Migrator::Migration::V1
  def migrate
    alter :users do
      add username : String, fill_existing_with: "Irrelevant as there are no users"
      add bio : String?
    end
  end

  def rollback
    # drop :things
  end
end
