defmodule Toolbox.RepoTest do
  use Toolbox.ModelCase

  alias Toolbox.Repo
  alias Toolbox.Factory

  test ".categories_with_packages sorts packages within sorted categories" do
    package_a2 = Factory.create(:package, name: "a2")
    package_a1 = Factory.create(:package, name: "a1")
    package_b = Factory.create(:package, name: "b")
    package_ab = Factory.create(:package, name: "ab")

    category_a = Factory.create(:category, name: "A")
    category_b = Factory.create(:category, name: "B")

    Toolbox.Categorization.categorize(package_a1, [category_a.id])
    Toolbox.Categorization.categorize(package_a2, [category_a.id])
    Toolbox.Categorization.categorize(package_b, [category_b.id])
    Toolbox.Categorization.categorize(package_ab, [category_a.id, category_b.id])

    [
      %Toolbox.Category{name: "A", packages: [^package_a1, ^package_a2, ^package_ab]},
      %Toolbox.Category{name: "B", packages: [^package_ab, ^package_b]},
    ] = Repo.categories_with_packages
  end

  test ".categories_with_packages excludes empty categories" do
    package_b = Factory.create(:package, name: "b")

    _category_a = Factory.create(:category, name: "A")
    category_b = Factory.create(:category, name: "B")

    Toolbox.Categorization.categorize(package_b, [category_b.id])

    [
      %Toolbox.Category{name: "B", packages: [^package_b]},
    ] = Repo.categories_with_packages
  end

  test ".categories_with_packages appends sorted uncategorized packages" do
    package_b = Factory.create(:package, name: "b")

    package_u2 = Factory.create(:package, name: "u2")
    package_u1 = Factory.create(:package, name: "u1")

    category_b = Factory.create(:category, name: "B")

    Toolbox.Categorization.categorize(package_b, [category_b.id])

    [
      %Toolbox.Category{name: "B", packages: [^package_b]},
      %Toolbox.Category{name: "Uncategorized", packages: [^package_u1, ^package_u2]},
    ] = Repo.categories_with_packages
  end
end
