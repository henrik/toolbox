defmodule Toolbox.Categorization do
  use Toolbox.Web, :model

  schema "categorizations" do
    belongs_to :category, Toolbox.Category
    belongs_to :package, Toolbox.Package

    timestamps
  end

  @required_fields ~w(category_id package_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def categorize(package, new_cids) do
    alias Toolbox.Repo

    old_cids = Repo.all(
      from c in for_package(package),
        select: c.category_id
    )

    add_cids = new_cids -- old_cids
    remove_cids = old_cids -- new_cids

    for cid <- add_cids do
      Repo.insert!(%__MODULE__{package_id: package.id, category_id: cid})
    end

    Repo.delete_all(
      from c in for_package(package),
      where: c.category_id in ^remove_cids
    )
  end

  defp for_package(package) do
    from c in __MODULE__,
      where: c.package_id == ^package.id
  end
end
