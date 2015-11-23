defmodule Toolbox.PackageView do
  use Toolbox.Web, :view
  alias Toolbox.Package
  alias Toolbox.Category

  def hex_url(%Package{name: name}) do
    "https://hex.pm/packages/#{name}"
  end

  def categories_for_select(categories) do
    for c <- categories do
      {c.name, c.id}
    end
  end

  def anchor(%Category{id: id}) do
    "p-#{id}"
  end

  def category_name(category) do
    case String.split(category.name, ": ", parts: 2) do
      [group, name] ->
        html_escape [
          content_tag(:span, group <> ":", class: "category-group"),
          " ",
          name,
        ]
      [name] ->
        name |> html_escape
    end
  end
end
