# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

if :dev == Mix.env do
  alias Toolbox.Package
  alias Toolbox.Repo

  IO.puts "Creating dev data…"

  time = "2010-04-17T14:00:00Z"
  Repo.insert! Package.changeset(%Package{}, %{name: "my_package", description: "My package.", hex_updated_at: time})
  Repo.insert! Package.changeset(%Package{}, %{name: "another_package", description: "Another package.", hex_updated_at: time})
end
