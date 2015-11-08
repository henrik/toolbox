defmodule Toolbox.PageController do
  use Toolbox.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
