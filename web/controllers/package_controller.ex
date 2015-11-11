defmodule Toolbox.PackageController do
  use Toolbox.Web, :controller
  alias Toolbox.Package

  def index(conn, _params) do
    packages = Repo.all(Package.sort_by_name)
    packages_count = Repo.one(Package.count)

    render(conn, "index.html", packages: packages, packages_count: packages_count)
  end
end
