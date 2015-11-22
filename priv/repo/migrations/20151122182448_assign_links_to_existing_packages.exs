defmodule Toolbox.Repo.Migrations.AssignLinksToExistingPackages do
  use Ecto.Migration
  import Ecto.Query

  def change do
    # To speed up dev, only do something if there are records to migrate.
    count = Toolbox.Repo |> Ectoo.count(Toolbox.Package)
    if count == 0 do
      IO.puts "No packages in DB, so not assigning"
    else
      # Migrations don't seem to run in the context of the Toolbox app, so we need to start this manually for the Hex client.
      :ok = Application.ensure_started(:ibrowse)
      update_from_page(1)
    end
  end

  defp update_from_page(page) do
    case get_packages_on_page(page) do
      [] ->
        # Empty page; stop.
        :noop
      packages ->
        for package <- packages do
          links = Dict.get(package["meta"], "links", %{})

          Toolbox.Repo.update_all(
            from(p in Toolbox.Package, where: p.name==^package["name"]),
            set: [links: links]
          )
        end
        update_from_page(page + 1)
    end
  end

  defp get_packages_on_page(page) do
    HexClient.packages(page: page, sort: "updated_at")
  end
end
