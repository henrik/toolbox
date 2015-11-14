defmodule Toolbox.Repo do
  use Ecto.Repo, otp_app: :toolbox

  def categories_with_packages do
    alias Toolbox.Category
    alias Toolbox.Package

    categories_with_categorized_packages = all(
      Category.sorted_with_sorted_packages
    )

    uncategorized_packages = all(
      Package.uncategorized |> Package.sort_by_name
    )

    if Enum.any?(uncategorized_packages) do
      categories_with_categorized_packages ++ [
        Category.uncategorized_category(uncategorized_packages)
      ]
    else
      categories_with_categorized_packages
    end
  end
end
