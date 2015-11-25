defmodule Toolbox.PageController do
  use Toolbox.Web, :controller

  def about(conn, _params) do
    conn
    |> assign(:page_title, "About")
    |> render "about.html"
  end
end
