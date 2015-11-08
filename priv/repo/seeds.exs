# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

if :dev == Mix.env do
  alias Toolbox.Factory

  IO.puts "Creating dev data…"

  Factory.create(:package, name: "my_package", description: "My package.")
  Factory.create(:package, name: "another_package", description: "Another package.")
end
