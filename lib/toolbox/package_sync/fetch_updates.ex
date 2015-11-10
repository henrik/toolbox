defmodule Toolbox.PackageSync.FetchUpdates do
  def fetch(client) do
    newest_in_db = Toolbox.Package.newest_hex_updated_at_with_names

    # Let's not parallelize this. It's fast enough at the time of writing, and there is also rate limiting.
    fetch_page(client, 1, newest_in_db)
  end

  defp fetch_page(client, page, newest_in_db, updated_packages_so_far \\ []) do
    all_packages_on_page = get_packages_on_page(client, page)
    {updated_packages, packages_in_db} = partition_packages(all_packages_on_page, newest_in_db)

    all_updated_packages = updated_packages_so_far ++ updated_packages

    case {packages_in_db, all_packages_on_page} do
      {_, []} ->
        # We're on an empty page.
        all_updated_packages
      {[_|_], _} ->
        # Page contains old packages, so next page will too. Stop.
        all_updated_packages
      _ ->
        # There's more to fetch.
        fetch_page(client, page + 1, newest_in_db, all_updated_packages)
    end
  end

  defp get_packages_on_page(client, page) do
    client.packages(page: page, sort: "updated_at")
  end

  defp partition_packages(packages, {time_of_newest_packages_in_db, names_of_newest_packages_in_db}) do
    Enum.split_while packages, fn (package) ->
      package_updated_at = package["updated_at"] |> parse_datetime

      # For a package to be considered "updated", it must:
      #
      # - be updated >= the newest packages from the previous update
      # - not be one of the newest packages from the previous update, if unchanged since
      #
      # This should ensure we don't miss any updates, even if we missed it by a nanosecond last update.

      case Ecto.DateTime.compare(package_updated_at, time_of_newest_packages_in_db) do
        :gt -> true
        :eq -> not(package["name"] in names_of_newest_packages_in_db)
        _ ->   false
      end
    end
  end

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
