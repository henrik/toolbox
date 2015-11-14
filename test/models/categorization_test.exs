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
  test "associations work" do
    categorization = Factory.create(:categorization)

    package = categorization.package |> Repo.preload(:categories)
    category = categorization.category |> Repo.preload(:packages)

    assert package.categories == [categorization.category]
    assert category.packages == [categorization.package]
  end

  test ".categorize" do
    _package_a = Factory.create(:package)
    package_b = Factory.create(:package)

    category_a = Factory.create(:category)
    category_b = Factory.create(:category)
    category_c = Factory.create(:category)

    Categorization.categorize(package_b, [category_a.id, category_b.id])

    assert get_categorizations == [
      [ package_b.id, category_a.id ],
      [ package_b.id, category_b.id ],
    ]

    Categorization.categorize(package_b, [category_a.id, category_c.id])

    assert get_categorizations == [
      [ package_b.id, category_a.id ],
      [ package_b.id, category_c.id ],
    ]
  end

  defp get_categorizations do
    Repo.all(
      from c in Categorization,
        select: [c.package_id, c.category_id],
        order_by: [asc: c.package_id, asc: c.category_id]
    )
  end
end
