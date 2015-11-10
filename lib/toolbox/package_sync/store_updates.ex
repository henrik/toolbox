defmodule Toolbox.PackageSync.StoreUpdates do
  alias Toolbox.Package
  alias Toolbox.Repo
  import Ecto.Query

  def store(packages_data) do
    these_names = for p <- packages_data, do: p["name"]

    pre_existing_names = Repo.all(
      from p in Package,
      select: p.name,
      where: p.name in ^these_names
    )

    {to_update, to_create} = Enum.split_while packages_data, fn (package) ->
      package["name"] in pre_existing_names
    end

    for package <- to_create do
      Repo.insert! Package.changeset(%Package{}, %{
        name: package["name"],
        description: package["meta"]["description"],
        hex_updated_at: package["updated_at"],
      })
    end

    for package <- to_update do
      name = package["name"]
      Repo.update_all(
        from(p in Package, where: p.name == ^name),
        set: [
          name: package["name"],
          description: package["meta"]["description"],
          hex_updated_at: package["updated_at"],
        ]
      )
    end
  end
end
