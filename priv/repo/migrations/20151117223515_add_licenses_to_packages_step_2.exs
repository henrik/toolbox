defmodule Toolbox.Repo.Migrations.AddLicensesToPackagesStep2 do
  use Ecto.Migration

  def change do
    # Step 2:
    # We'll do this in two steps to get NOT NULL with DRY defaults :/
    # https://github.com/elixir-lang/ecto/issues/1091

    Toolbox.Repo.update_all(Toolbox.Package, set: [licenses: []])

    alter table(:packages) do
      modify :licenses, {:array, :string}, null: false
    end
  end
end
