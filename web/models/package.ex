defmodule Toolbox.Package do
  use Toolbox.Web, :model

  schema "packages" do
    field :name, :string
    field :description, :string
    field :hex_updated_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(name description hex_updated_at)
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
