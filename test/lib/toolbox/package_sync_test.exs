defmodule Toolbox.PackageSyncTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # Run with DB transaction. Stolen from ConnCase.
  # TODO: Clean this up.
  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Toolbox.Repo, [])
    end

    :ok
  end

  defmodule FakeHexClient do
    defmodule Packages do
      def a, do: %{"name" => "a", "updated_at" => "2001-01-01T00:00:00Z", "meta" => %{"description" => "A."}}
      def b, do: %{"name" => "b", "updated_at" => "2002-01-01T00:00:00Z", "meta" => %{"description" => "B."}}

      # Exact same timestamp to test border case.
      def c, do: %{"name" => "c", "updated_at" => "2003-01-01T00:00:00Z", "meta" => %{"description" => "C."}}
      def d, do: %{"name" => "d", "updated_at" => "2003-01-01T00:00:00Z", "meta" => %{"description" => "D."}}

      def e, do: %{"name" => "e", "updated_at" => "2004-01-01T00:00:00Z", "meta" => %{"description" => "E."}}

      def updated_a, do: %{"name" => "a", "updated_at" => "2005-01-01T00:00:00Z", "meta" => %{"description" => "Updated A."}}
    end

    defmodule State1 do
      import FakeHexClient.Packages
      def packages(page: 1, sort: "updated_at"), do: [ c, b ]
      def packages(page: 2, sort: "updated_at"), do: [ a ]
      def packages(page: 3, sort: "updated_at"), do: []
    end

    defmodule State2 do
      import FakeHexClient.Packages
      def packages(page: 1, sort: "updated_at"), do: [e, d, c]
    end

    defmodule State3 do
      import FakeHexClient.Packages
      def packages(page: 1, sort: "updated_at"), do: [updated_a, e]
    end
  end

  test "it creates any new packages in DB" do
    assert package_names == []

    silence_output fn ->
      Toolbox.PackageSync.run(FakeHexClient.State1)
    end

    assert package_names == ~w[a b c]

    silence_output fn ->
      Toolbox.PackageSync.run(FakeHexClient.State2)
    end

    assert package_names == ~w[a b c d e]

    assert first_package.name == "a"
    assert first_package.description == "A."
    assert first_package.hex_updated_at == parse_datetime("2001-01-01T00:00:00Z")

    silence_output fn ->
      Toolbox.PackageSync.run(FakeHexClient.State3)
    end

    assert package_names == ~w[a b c d e]

    assert first_package.name == "a"
    assert first_package.description == "Updated A."
    assert first_package.hex_updated_at == parse_datetime("2005-01-01T00:00:00Z")
  end

  defp silence_output(fun), do: capture_io(fun)

  defp first_package, do: load_packages |> hd
  defp package_names, do: load_packages |> Enum.map &(&1.name)
  defp load_packages, do: Toolbox.Repo.all(Toolbox.Package.sort_by_name)

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
