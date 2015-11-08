defmodule Toolbox.PackageController do
  use Toolbox.Web, :controller

  alias Toolbox.Package

  def index(conn, _params) do
    packages = Repo.all(Package.sort_by_name)

    render(conn, "index.html", packages: packages)
  end
end
