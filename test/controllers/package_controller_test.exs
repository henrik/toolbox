defmodule Toolbox.PackageControllerTest do
  use Toolbox.ConnCase
  alias Toolbox.Package

  test "GET / lists packages" do
    package = Repo.insert! %Package{name: "my_package", description: "My package."}

    conn = get conn(), "/"
    response = html_response(conn, 200)

    assert response =~ "my_package"
    assert response =~ "My package."
  end
end
