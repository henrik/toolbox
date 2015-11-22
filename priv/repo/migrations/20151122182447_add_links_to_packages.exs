defmodule Toolbox.Repo.Migrations.AddLinksToPackages do
  use Ecto.Migration

  def change do
    alter table(:packages) do
      # We'll probably make this NOT NULL later.
      add :links, :map, null: true
    end
  end
end
