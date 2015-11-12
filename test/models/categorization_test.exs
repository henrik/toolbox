defmodule Toolbox.CategorizationTest do
  use Toolbox.ModelCase

  alias Toolbox.Repo
  alias Toolbox.Factory
  alias Toolbox.Categorization

  @valid_attrs %{package_id: 1, category_id: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Categorization.changeset(%Categorization{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Categorization.changeset(%Categorization{}, @invalid_attrs)
    refute changeset.valid?
  end

  # For some confidence that the many-to-many association is set up correctly.
  # TODO: Is this the right place to test these things?
  test "associations work" do
    categorization = Factory.create(:categorization)

    package = categorization.package |> Repo.preload(:categories)
    category = categorization.category |> Repo.preload(:packages)

    assert package.categories == [categorization.category]
    assert category.packages == [categorization.package]
  end
end
