defmodule Toolbox.Repo.Migrations.IndexPackagesOnName do
  use Ecto.Migration

  def change do
    create index :packages, [:name]
  end
end
