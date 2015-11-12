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
end
