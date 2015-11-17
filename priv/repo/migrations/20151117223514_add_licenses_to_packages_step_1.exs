defmodule Toolbox.Repo.Migrations.AddLicensesToPackagesStep1 do
  use Ecto.Migration

  def change do
    # Step 1:
    # We'll do this in two steps to get NOT NULL with DRY defaults :/
    # https://github.com/elixir-lang/ecto/issues/1091

    alter table(:packages) do
      add :licenses, {:array, :string}, null: true
    end
  end
end
