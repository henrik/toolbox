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
    end

    defmodule OlderState do
      import FakeHexClient.Packages
      def packages(page: 1, sort: "updated_at"), do: [ c, b ]
      def packages(page: 2, sort: "updated_at"), do: [ a ]
      def packages(page: 3, sort: "updated_at"), do: []
    end

    defmodule NewerState do
      import FakeHexClient.Packages
      def packages(page: 1, sort: "updated_at"), do: [e, d, c]
    end
  end

  test "it creates any new packages in DB" do
    assert package_names == []

    capture_io fn ->
      Toolbox.PackageSync.run(FakeHexClient.OlderState)
    end

    assert package_names == ~w[a b c]

    capture_io fn ->
      Toolbox.PackageSync.run(FakeHexClient.NewerState)
    end

    assert package_names == ~w[a b c d e]

    first_package = load_packages |> hd
    assert first_package.name == "a"
    assert first_package.description == "A."
    assert first_package.hex_updated_at == parse_datetime("2001-01-01T00:00:00Z")
  end

  defp package_names do
    load_packages |> Enum.map &(&1.name)
  end

  defp load_packages do
    Toolbox.Repo.all(Toolbox.Package.sort_by_name)
  end

  defp parse_datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
