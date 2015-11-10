# TODO: Schedule this. Until then, run manually like so:
#
#     mix run -e 'Toolbox.PackageSync.run'
#     ssh dokku run toolbox mix run -e 'Toolbox.PackageSync.run'

defmodule Toolbox.PackageSync do
  def run(client \\ HexClient) do
    client
    |> Toolbox.PackageSync.FetchUpdates.fetch
    |> Toolbox.PackageSync.StoreUpdates.store
  end
end
