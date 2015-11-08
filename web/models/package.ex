defmodule Toolbox.Package do
  use Toolbox.Web, :model

  schema "packages" do
    field :name, :string
    field :description, :string
    field :hex_updated_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(name hex_updated_at)
  @optional_fields ~w(description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def sort_by_name(query \\ Toolbox.Package) do
    import Ecto.Query

    from p in query,
      order_by: [asc: p.name]
  end

  def newest_hex_updated_at_with_names do
    case Toolbox.Repo.all(newest_hex_updated_at_with_names_query) do
      [] ->
        beginning_of_time = parse_datetime("0000-01-01T00:00:00Z")
        {beginning_of_time, []}
      [[updated_at, _]|_] = list ->
        names = Enum.map(list, fn [_, name] -> name end)
        {updated_at, names}
    end
  end

  defp newest_hex_updated_at_with_names_query do
    import Ecto.Query

    from p in Toolbox.Package,
      where: fragment(
        "? IN (SELECT MAX(packages.hex_updated_at) FROM packages)",
        p.hex_updated_at
      ),
      select: [p.hex_updated_at, p.name]
  end

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
