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

  defp run(client, page, {no_older_than_time, names_on_the_limit} = newest_data) do
    packages = client.packages(page: page, sort: "updated_at")

    {updated_packages, old_packages} = Enum.split_while packages, fn (package) ->
      pup = package["updated_at"] |> parse_datetime

      case Ecto.DateTime.compare(pup, no_older_than_time) do
        :gt -> true
        :eq -> not (package["name"] in names_on_the_limit)
        _ -> false
      end
    end

    IO.inspect page: page, updated: length(updated_packages), old: length(old_packages)

    update_or_create(updated_packages)

    # checking length is a bit inefficient
    should_stop? = length(old_packages) > 0 or length(packages) == 0

    if should_stop? do
      IO.puts "Let's stop."
    else
      run(client, page + 1, newest_data)
    end
  end

  defp update_or_create(packages) do
    alias Toolbox.Package
    alias Toolbox.Repo

    IO.inspect should_up: length(packages)

    # TODO: unique name in DB
    # TODO: find or create, don't always create
    for package <- packages do
      Repo.insert! Package.changeset(%Package{}, %{
        name: package["name"],
        description: package["meta"]["description"],
        hex_updated_at: package["updated_at"],
      })
    end
  end

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
