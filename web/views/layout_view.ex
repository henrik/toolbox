defmodule Toolbox.LayoutView do
  use Toolbox.Web, :view

  def menu_link(%Plug.Conn{request_path: path}, text, to: path) do
    menu_link(text, to: path, extra_classes: "site-menu__link--current")
  end

  def menu_link(_, text, to: path) do
    menu_link(text, to: path, extra_classes: "")
  end

  defp menu_link(text, to: path, extra_classes: extra_classes) do
    link(text, to: path, class: "site-menu__link #{extra_classes}")
  end
end
