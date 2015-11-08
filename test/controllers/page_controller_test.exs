defmodule Toolbox.PageControllerTest do
  use Toolbox.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "TODO: Everything"
  end
end
