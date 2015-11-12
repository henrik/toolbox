defmodule Toolbox.CategorizationTest do
  use Toolbox.ModelCase

  alias Toolbox.Repo
  alias Toolbox.Factory
  alias Toolbox.Categorization
  alias Toolbox.Package
  alias Toolbox.Category

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

  # TODO: Is this the right place to test these things?
  # We can probably remove this test anyway.
  test "associations work" do
    categorization = Factory.create(:categorization)

    assert %Package{} = categorization.package
    assert %Category{} = categorization.category

    package = Repo.get(Package, categorization.package.id) |> Repo.preload(:categories)
    assert package.categories == [categorization.category]
  end
end
