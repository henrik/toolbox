defmodule Toolbox.PackageController do
  use Toolbox.Web, :controller

  alias Toolbox.Package

  plug :scrub_params, "package" when action in [:create, :update]

  def index(conn, _params) do
    packages = Repo.all(Package)
    render(conn, "index.html", packages: packages)
  end
end
