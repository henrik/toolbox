# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

if :dev == Mix.env do
  alias Toolbox.Package
  alias Toolbox.Repo

  IO.puts "Creating dev data…"

  Toolbox.Repo.insert! %Package{name: "my_package", description: "My package."}
  Toolbox.Repo.insert! %Package{name: "another_package", description: "Another package."}
end
