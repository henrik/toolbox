defmodule Toolbox.PackageController do
  use Toolbox.Web, :controller
  alias Toolbox.Package
  alias Toolbox.Category
  alias Toolbox.Categorization

  plug :scrub_params, "package" when action in [:update]

  def index(conn, _params) do
    packages_count = Repo.one(Package.count)
    uncategorized_count = Repo.one(Package.uncategorized |> Package.count)

    render conn, "index.html",
      categories_with_packages: Repo.categories_with_packages,
      packages_count: packages_count,
      uncategorized_count: uncategorized_count
  end

  def edit(conn, %{"id" => name}) do
    package = Repo.get_by!(Package.with_categories, name: name)
    all_categories = Repo.all(Category.sort_by_name)

    changeset = Package.changeset(package)

    conn
    |> assign(:page_title, "Edit \"#{package.name}\"")
    |> render("edit.html", package: package, all_categories: all_categories, changeset: changeset)
  end

  def update(conn, %{"id" => id, "package" => %{ "categories" => cids }}) do
    package = Repo.get!(Package, id)
    category_ids = Enum.map cids, &String.to_integer/1

    Categorization.categorize(package, category_ids)

    conn
    |> put_flash(:info, "Package categorized!")
    |> redirect(to: package_path(conn, :index))
  end
end
