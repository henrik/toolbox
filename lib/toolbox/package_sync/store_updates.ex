defmodule Toolbox.PackageSync.StoreUpdates do
  alias Toolbox.Package
  alias Toolbox.Repo
  import Ecto.Query

  def store(packages_data) do
    {to_update, to_create} = partition_data(packages_data)

    for data <- to_create, do: create_package(data)
    for data <- to_update, do: update_package(data)
  end

  defp partition_data(packages_data) do
    pre_existing_names = find_pre_existing_names(packages_data)

    Enum.partition packages_data, fn (package) ->
      package["name"] in pre_existing_names
    end
  end

  defp find_pre_existing_names(packages_data) do
    names_of_updated_packages = for data <- packages_data, do: data["name"]

    Repo.all(
      from p in Package,
      select: p.name,
      where: p.name in ^names_of_updated_packages
    )
  end

  defp create_package(data) do
    Repo.insert!(
      Package.changeset(%Package{}, changes_from_data(data))
    )
  end

  defp update_package(data) do
    name = data["name"]
    changes_as_keyword_list = data |> changes_from_data |> Enum.into([])

    Repo.update_all(
      from(p in Package, where: p.name == ^name),
      set: changes_as_keyword_list
    )
  end

  defp changes_from_data(data) do
    %{
      name:           data["name"],
      description:    data["meta"]["description"],
      licenses:       data["meta"]["licenses"] || [],
      hex_updated_at: data["updated_at"],
    }
  end
end
