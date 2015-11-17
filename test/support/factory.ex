defmodule Toolbox.Factory do
  use ExMachina.Ecto, repo: Toolbox.Repo

  alias Toolbox.Package
  alias Toolbox.Category
  alias Toolbox.Categorization

  def factory(:package, attrs) do
    # :/ https://github.com/thoughtbot/ex_machina/issues/54
    time = Dict.get(attrs, :hex_updated_at, "2001-02-03T04:05:06Z")
    {:ok, cast_time} = Ecto.DateTime.cast(time)

    %Package{
      name: sequence(:name, &"package#{&1}"),
      description: "A package.",
      licenses: ["MIT"],
      hex_updated_at: cast_time,
    }
  end

  def factory(:category, _attrs) do
    %Category{
      name: sequence(:name, &"Category #{&1}"),
    }
  end

  def factory(:categorization, attrs) do
    %Categorization{
      package: assoc(attrs, :package),
      category: assoc(attrs, :category),
    }
  end
end
