defmodule Toolbox.PackageControllerTest do
  use Toolbox.ConnCase

  alias Toolbox.Factory
  alias Toolbox.Package

  test "GET / lists packages" do
    Factory.create(:package, name: "my_package", description: "My package.")

    conn = get conn(), "/"
    response = html_response(conn, 200)

    assert response =~ "my_package"
    assert response =~ "My package."
  end

  test "GET /packages/:name/edit shows form to categorize" do
    package = Factory.create(:package, name: "my_package")
    Factory.create(:category, name: "Examples")

    conn = get conn(), package_path(conn, :edit, package.name)
    response = html_response(conn, 200)

    assert response =~ "my_package"
    assert response =~ "Examples"
  end

  test "PUT /packages/:name assigns categories" do
    package = Factory.create(:package, name: "my_package")
    category_a = Factory.create(:category, name: "Examples")
    category_b = Factory.create(:category, name: "Anothers")

    assert assigned_categories(package) == []

    conn = put conn, package_path(conn, :update, package),
      package: [ categories: ["#{category_a.id}", "#{category_b.id}"] ]
    assert redirected_to(conn) == package_path(conn, :index)

    assert assigned_categories(package) == [category_a, category_b]
  end

  defp assigned_categories(package) do
    Repo.get!(Package.with_categories, package.id).categories
  end
end
