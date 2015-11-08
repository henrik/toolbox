defmodule Toolbox.Repo.Migrations.CreatePackage do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :name, :string, null: false
      add :description, :text, null: true
      add :hex_updated_at, :datetime, null: false

      timestamps
    end

  end
end
