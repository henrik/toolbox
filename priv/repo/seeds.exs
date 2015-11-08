# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Toolbox.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if :dev == Mix.env do
  alias Toolbox.Package

  IO.puts "Creating dev data…"

  Toolbox.Repo.insert! %Package{name: "my_package", description: "My package."}
  Toolbox.Repo.insert! %Package{name: "another_package", description: "Another package."}
end
