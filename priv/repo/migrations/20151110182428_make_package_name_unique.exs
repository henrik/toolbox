defmodule Toolbox.Repo.Migrations.MakePackageNameUnique do
  use Ecto.Migration

  def change do
    drop index :packages, [:name]
    create unique_index :packages, [:name]
  end
end
