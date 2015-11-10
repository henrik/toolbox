# TODO: Clean up :O!
# TODO: Schedule this. Until then, run manually like so:
#
#     mix run -e 'Toolbox.PackageSync.run'
#     ssh dokku run toolbox mix run -e 'Toolbox.PackageSync.run'

defmodule Toolbox.PackageSync do
  def run(client \\ HexClient) do
    # Let's not parallelize this. It's fast enough at the time of writing, and there is also rate limiting.
    run(client, 1, Toolbox.Package.newest_hex_updated_at_with_names)
  end

  defp run(client, page, newest_data) do
    packages = get_packages_on_page(client, page)
    {updated_packages, old_packages} = partition_packages(packages, newest_data)

    update_or_create(updated_packages)

    case {old_packages, packages} do
      {_, []}    -> :noop # We're on an empty page. Stop.
      {[_|_], _} -> :noop # Page contains old packages, so next page will too. Stop.
      _          -> run(client, page + 1, newest_data)
    end
  end

  defp get_packages_on_page(client, page) do
    client.packages(page: page, sort: "updated_at")
  end

  defp partition_packages(packages, {no_older_than_time, names_on_the_limit}) do
    Enum.split_while packages, fn (package) ->
      package_updated_at = package["updated_at"] |> parse_datetime

      case Ecto.DateTime.compare(package_updated_at, no_older_than_time) do
        :gt -> true
        :eq -> not (package["name"] in names_on_the_limit)
        _ -> false
      end
    end
  end

  defp update_or_create(packages) do
    alias Toolbox.Package
    alias Toolbox.Repo
    import Ecto.Query

    these_names = for p <- packages, do: p["name"]

    pre_existing_names = Repo.all(
      from p in Package,
      select: p.name,
      where: p.name in ^these_names
    )

    {to_update, to_create} = Enum.split_while packages, fn (package) ->
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

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
