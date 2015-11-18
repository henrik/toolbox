defmodule Toolbox.Repo.Migrations.AssignLicensesToExistingPackages do
  use Ecto.Migration
  import Ecto.Query

  def change do
    # To speed up dev, only do something if there are records to migrate.
    count = Toolbox.Repo.one(from(p in Toolbox.Package, select: count(p.id)))
    if count == 0 do
      IO.puts "No packages in DB, so not assigning licenses"
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
          licenses = Dict.get(package["meta"], "licenses", [])

          Toolbox.Repo.update_all(
            from(p in Toolbox.Package, where: p.name==^package["name"]),
            set: [licenses: licenses]
          )
        end
        update_from_page(page + 1)
    end
  end

  defp get_packages_on_page(page) do
    HexClient.packages(page: page, sort: "updated_at")
  end
end
