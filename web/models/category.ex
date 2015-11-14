defmodule Toolbox.Category do
  use Toolbox.Web, :model

  schema "categories" do
    field :name, :string

    has_many :categorizations, Toolbox.Categorization,
      on_delete: :delete_all

    has_many :packages, through: [:categorizations, :package]

    timestamps
  end

  @required_fields ~w(name)
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

  def uncategorized_category(packages) do
    %__MODULE__{
      name: "Uncategorized",
      packages: packages,
    }
  end

  def sort_by_name(query \\ __MODULE__) do
    Ecto.Query.from c in query,
      order_by: [asc: c.name]
  end

  def sorted_with_sorted_packages(query \\ __MODULE__) do
    Ecto.Query.from c in query,
      join: p in assoc(c, :packages),
      distinct: true,
      preload: [packages: p],
      order_by: [asc: c.name, asc: p.name]
  end
end
