defmodule Toolbox.PackageView do
  use Toolbox.Web, :view
  alias Toolbox.Package

  def hex_url(%Package{name: name}) do
    "https://hex.pm/packages/#{name}"
  end
end
