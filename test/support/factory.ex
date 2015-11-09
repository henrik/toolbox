defmodule Toolbox.Factory do
  alias Toolbox.Package
  use ExMachina.Ecto, repo: Toolbox.Repo

  def factory(:package, attrs) do
    # :/ https://github.com/thoughtbot/ex_machina/issues/54
    time = Dict.get(attrs, :hex_updated_at, "2001-02-03T04:05:06Z")
    {:ok, cast_time} = Ecto.DateTime.cast(time)

    %Package{
      name: sequence(:name, &"package#{&1}"),
      description: "A package.",
      hex_updated_at: cast_time,
    }
  end
end
