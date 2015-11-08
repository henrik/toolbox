defmodule Toolbox.PackageController do
  use Toolbox.Web, :controller

  alias Toolbox.Package

  plug :scrub_params, "package" when action in [:create, :update]

  def index(conn, _params) do
    packages = Repo.all(Package)
    render(conn, "index.html", packages: packages)
  end

  def new(conn, _params) do
    changeset = Package.changeset(%Package{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"package" => package_params}) do
    changeset = Package.changeset(%Package{}, package_params)

    case Repo.insert(changeset) do
      {:ok, _package} ->
        conn
        |> put_flash(:info, "Package created successfully.")
        |> redirect(to: package_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)
    render(conn, "show.html", package: package)
  end

  def edit(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)
    changeset = Package.changeset(package)
    render(conn, "edit.html", package: package, changeset: changeset)
  end

  def update(conn, %{"id" => id, "package" => package_params}) do
    package = Repo.get!(Package, id)
    changeset = Package.changeset(package, package_params)

    case Repo.update(changeset) do
      {:ok, package} ->
        conn
        |> put_flash(:info, "Package updated successfully.")
        |> redirect(to: package_path(conn, :show, package))
      {:error, changeset} ->
        render(conn, "edit.html", package: package, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: package_path(conn, :index))
  end
end
