defmodule Toolbox.PageControllerTest do
  use Toolbox.ConnCase

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "renders", %{conn: conn} do
    conn = get conn, page_path(conn, :about)
    assert html_response(conn, 200) =~ "About"
  end
end
