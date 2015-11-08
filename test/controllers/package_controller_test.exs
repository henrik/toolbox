defmodule Toolbox.PackageControllerTest do
  use Toolbox.ConnCase
  alias Toolbox.Package

  test "GET / lists packages" do
    {:ok, time} = Ecto.DateTime.cast({{2010, 4, 17}, {14, 0, 0}})
    Repo.insert! %Package{name: "my_package", description: "My package.", hex_updated_at: time}

    conn = get conn(), "/"
    response = html_response(conn, 200)

    assert response =~ "my_package"
    assert response =~ "My package."
  end
end
