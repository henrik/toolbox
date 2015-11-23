defmodule Toolbox.PackageViewTest do
  use Toolbox.ConnCase, async: true

  test ".category_name marks out category groups" do
    category = %Toolbox.Category{name: "Foo: Bar"}

    actual = Toolbox.PackageView.category_name(category) |> Phoenix.HTML.safe_to_string

    assert actual =~ ">Foo:<"
    assert actual =~ "Bar"
  end

  test ".category_name handles multiple ':'" do
    category = %Toolbox.Category{name: "Foo: Bar: Baz"}

    actual = Toolbox.PackageView.category_name(category) |> Phoenix.HTML.safe_to_string

    assert actual =~ ">Foo:<"
    assert actual =~ "Bar: Baz"
  end

  test ".category_name escapes user-provided content" do
    category = %Toolbox.Category{name: "F&o: B&r"}

    actual = Toolbox.PackageView.category_name(category) |> Phoenix.HTML.safe_to_string

    assert actual =~ "F&amp;o"
    assert actual =~ "B&amp;r"
  end

  test ".category_name leaves non-group names alone" do
    category = %Toolbox.Category{name: "F&o"}

    actual = Toolbox.PackageView.category_name(category) |> Phoenix.HTML.safe_to_string

    assert actual == "F&amp;o"
  end
end
