defmodule Toolbox.Repo.Migrations.CreatePackage do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :name, :string
      add :description, :text
      add :hex_updated_at, :datetime

      timestamps
    end

  end
end
