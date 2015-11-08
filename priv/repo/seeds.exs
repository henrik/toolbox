# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

if :dev == Mix.env do
  alias Toolbox.Package
  alias Toolbox.Repo

  IO.puts "Creating dev data…"

  {:ok, time} = Ecto.DateTime.cast({{2010, 4, 17}, {14, 0, 0}})

  Repo.insert! %Package{name: "my_package", description: "My package.", hex_updated_at: time}
  Repo.insert! %Package{name: "another_package", description: "Another package.", hex_updated_at: time}
end
