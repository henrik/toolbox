defmodule Toolbox.Repo.Migrations.MakeCategorizationFieldsNonNull do
  use Ecto.Migration

  def change do
    alter table(:categorizations) do
      modify :category_id, :integer, null: false
      modify :package_id, :integer, null: false
    end
  end
end
