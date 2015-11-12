defmodule Toolbox.Repo.Migrations.AddCategorizations do
  use Ecto.Migration

  def change do
    create table(:categorizations) do
      add :category_id, references(:categories)
      add :package_id, references(:packages)

      timestamps
    end

    create unique_index :categorizations, [:category_id, :package_id]
  end
end
